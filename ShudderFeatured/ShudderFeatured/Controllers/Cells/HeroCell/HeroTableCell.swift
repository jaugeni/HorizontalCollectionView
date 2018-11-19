//
//  HeroTableCell.swift
//  ShudderFeatured
//
//  Created by YAUHENI IVANIUK on 10/31/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

class HeroTableCell: UITableViewCell {
  
  private enum Constants {
    static let movieCell = "HeroCollectionCell"
  }
  
  @IBOutlet weak var heroCollection: UICollectionView!
  
  var dataSource: DataSource?
  var sectionCategory = 0
  private let activityView = UIActivityIndicatorView(style: .whiteLarge)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    NotificationCenter.default.addObserver(forName: .heroIsReady, object: nil, queue: nil) { [weak self] (_)   in
      guard let self = self else { return }
      self.setDelegates()
    }
  }
  
  private func setDelegates() {
    isLoading = false
    heroCollection.dataSource = self
    heroCollection.delegate = self
    heroCollection.reloadData()
    NotificationCenter.default.removeObserver(self)
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
}

extension HeroTableCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let dataSource = dataSource else { return 0 }
    return dataSource.numberOfImageCell(in: section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.movieCell, for: indexPath) as? HeroCollectionCell, let dataSource = dataSource else { return UICollectionViewCell() }
    cell.movieImage.image = dataSource.imageForCell(in: sectionCategory, for: indexPath.row)
    return cell
  }
}

extension HeroTableCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = collectionView.frame.height
    let width = collectionView.frame.width - 50
    
    return CGSize(width: width, height: height)
  }
}
