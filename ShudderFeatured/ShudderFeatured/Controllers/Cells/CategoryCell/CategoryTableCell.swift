//
//  CategoryCell.swift
//  ShudderFeatured
//
//  Created by YAUHENI IVANIUK on 10/30/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

class CategoryTableCell: UITableViewCell {
  
  private enum Constants {
    static let movieCell = "MovieImageCollectionCell"
  }
  
  @IBOutlet weak var categoryCollection: UICollectionView!
  
  var dataSource: DataSource?
  var sectionCategory = 0
  private let activityView = UIActivityIndicatorView(style: .whiteLarge)

  override func awakeFromNib() {
    super.awakeFromNib()
    NotificationCenter.default.addObserver(forName: .categorysIsReady, object: nil, queue: nil) { [weak self] (_)   in
      guard let self = self else { return }
      self.setDelegates()
    }
    categoryCollection.setContentOffset(categoryCollection.contentOffset, animated: false)
  }
  
  var isLoading: Bool = false {
    didSet {
      if isLoading {
        activityView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        activityView.startAnimating()
        self.addSubview(activityView)
      } else {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
      }
    }
  }
  
  var collectionViewOffset: CGFloat {
    set { categoryCollection.contentOffset.x = newValue }
    get { return categoryCollection.contentOffset.x }
  }
  
  private func setDelegates() {
    categoryCollection.dataSource = self
    categoryCollection.delegate = self
    categoryCollection.reloadData()
    isLoading = false
    NotificationCenter.default.removeObserver(self)
  }
}

extension CategoryTableCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let dataSource = dataSource else { return 0 }
    return dataSource.numberOfImageCell(in: sectionCategory)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.movieCell, for: indexPath) as? MovieImageCollectionCell, let dataSource = dataSource else { return UICollectionViewCell() }
    cell.movieImage.image = dataSource.imageForCell(in: sectionCategory, for: indexPath.row)
    return cell
  }
}

extension CategoryTableCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = collectionView.frame.height
    let width = height / 1.5
    
    return CGSize(width: width, height: height)
  }
}
