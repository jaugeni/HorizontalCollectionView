//
//  ViewController.swift
//  ShudderFeatured
//
//  Created by YAUHENI IVANIUK on 10/29/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

class FeaturedVC: UITableViewController {
  
  private enum Constants {
    static let categoryCellID = "CategoryTableCell"
    static let heroCellId = "HeroTableCell"
  }
  
  private var dataSource = DataSource()
  
  @IBOutlet weak private var featuredTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource.delegate = self
  }
}

extension FeaturedVC: DataSourceProtocol {
  func dataIsReady(status: Bool) {
    if status {
      featuredTableView.reloadData()
    }
  }
  
  func dataError(error: String) {
    print(error)
  }
}

extension FeaturedVC {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath == IndexPath(row: 0, section: 0) {
      guard let heroCell = tableView.dequeueReusableCell(withIdentifier: Constants.heroCellId, for: indexPath) as? HeroTableCell else { return UITableViewCell() }
      heroCell.isLoading = dataSource.isLoadingImagesFor(indexPath.section)
      heroCell.sectionCategory = indexPath.section
      heroCell.dataSource = dataSource
      return heroCell
    } else {
      guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCellID, for: indexPath) as? CategoryTableCell else { return UITableViewCell() }
      categoryCell.isLoading = dataSource.isLoadingImagesFor(indexPath.section)
      categoryCell.sectionCategory = indexPath.section
      categoryCell.dataSource = dataSource
      categoryCell.collectionViewOffset = dataSource.offsetFor(indexPath.section) ?? 0
      categoryCell.categoryCollection?.reloadData()
      return categoryCell
    }
  }
  
  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableViewCell = cell as? CategoryTableCell else { return }
    dataSource.setOffsetsFor(indexPath.section, offset: tableViewCell.collectionViewOffset)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath == IndexPath(row: 0, section: 0) {
      return 200
    } 
    return 166
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 3
    }
    return 25
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return nil
    }
    return dataSource.titleForHeaderFor(section)
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel?.textColor = .lightGray
    header.textLabel?.text = header.textLabel?.text?.capitalized
    header.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
  }
  
}
