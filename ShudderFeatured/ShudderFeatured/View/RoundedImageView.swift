//
//  RoundedImageView.swift
//  ShudderFeatured
//
//  Created by YAUHENI IVANIUK on 11/1/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

  override func prepareForInterfaceBuilder() {
    customizeView()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    customizeView()
  }
  
  func customizeView() {
    layer.cornerRadius = 5.0
  }
}
