//
//  ShadowToTableViewCell.swift
//  ShudderFeatured
//
//  Created by YAUHENI IVANIUK on 11/1/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

class ShadowToTableViewCell: UICollectionViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setView()
  }
  
  func setView() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 2.0
    layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    layer.masksToBounds = false
  }
}
