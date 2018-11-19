//
//  DataSource.swift
//  ShudderFeatured
//
//  Created by YAUHENI IVANIUK on 11/1/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

protocol DataSourceProtocol {
  func dataIsReady(status: Bool)
  func dataError(error: String)
}

class DataSource {
  
  private enum Constant {
    static let newlyAdded = "Newly Added"
    static let curatorsChoice = "Curator's Choice"
    static let onlyOnShudder = "Only On Shudder"
    static let hero = "Hero"
  }
  
  private var queryFlickrImages: QueryFlickrImages?
  private var featureds = [FeaturedModel]()
  
  var delegate: DataSourceProtocol?
  
  init() {
    queryFlickrImages = QueryFlickrImages()
    queryFlickrImages?.delegate = self
  }
  
  var numberOfSections: Int {
    return featureds.count
  }
  
  func titleForHeaderFor(_ section: Int) -> String {
    return featureds[section].categoryTitle
  }
  
  func setOffsetsFor(_ section: Int, offset: CGFloat) {
    featureds[section].storedOffsets = offset
  }
  
  func offsetFor(_ section: Int) -> CGFloat? {
    return featureds[section].storedOffsets
  }
  
  func numberOfImageCell(in section: Int) -> Int {
    return featureds[section].collections.count
  }
  
  func imageForCell(in section: Int, for index: Int) -> UIImage? {
    guard let image = featureds[section].collections[index].image else { return nil }
    return image
  }
  
  func isLoadingImagesFor(_ section: Int) -> Bool  {
    getImagesForCategory(index: section)
    return featureds[section].isLoading
  }
  
  //MARK: Helpers
  private func createFeatureds(with imagesUrl: [String]) -> [FeaturedModel] {
    let heroCateggory = FeaturedModel(categoryTitle: Constant.hero, collections: createImageModelWith(imagesUrl: imagesUrl, isHero: true), storedOffsets: nil, isLoading: true)
    let newlyAdded = FeaturedModel(categoryTitle: Constant.newlyAdded, collections: createImageModelWith(imagesUrl: imagesUrl, isHero: false), storedOffsets: nil, isLoading: true)
    let curatorsChoice = FeaturedModel(categoryTitle: Constant.curatorsChoice, collections: createImageModelWith(imagesUrl: imagesUrl, isHero: false), storedOffsets: nil, isLoading: true)
    let onlyOnShudder = FeaturedModel(categoryTitle: Constant.onlyOnShudder, collections: createImageModelWith(imagesUrl: imagesUrl, isHero: false), storedOffsets: nil, isLoading: true)
    let featureds = [heroCateggory, newlyAdded, curatorsChoice, onlyOnShudder]
    return featureds
  }
  
  private func createImageModelWith(imagesUrl: [String], isHero: Bool) -> [ImageModel] {
    var imageMpdel = [ImageModel]()
    let rundomNumberOfImages = isHero ? 3 : Int.random(in: 7...15)
    for _ in 1...rundomNumberOfImages {
      if let imageUrl = imagesUrl.randomElement() {
        let tempImageModel = ImageModel(imageUrl: imageUrl, image: nil)
        imageMpdel.append(tempImageModel)
      }
    }
    return imageMpdel
  }
  
  private func getImagesForCategory(index: Int) {
    for (i, colletion) in featureds[index].collections .enumerated(){
      let imageUrl = colletion.imageUrl
      queryFlickrImages?.dowloadImageFor(url: imageUrl, completionHandler: { [weak self] (image) in
        guard let self = self else { return }
        if let image = image {
          self.featureds[index].collections[i].image = image
          self.isAllImageFor(sectin: index)
        }
      })
    }
  }
  
  private func isAllImageFor(sectin: Int){
    let total = featureds[sectin].collections.count
    var count = 0
    for imageModel in featureds[sectin].collections {
      if let _ = imageModel.image {
        count += 1
      }
    }
    if total == count {
      if sectin == 0 {
        featureds[sectin].isLoading = false
        NotificationCenter.default.post(name: .heroIsReady, object: nil)
      } else {
        featureds[sectin].isLoading = false
        NotificationCenter.default.post(name: .categorysIsReady, object: nil)
      }
    }
  }
}

extension DataSource: QueryFlickrImagesProtocol {
  func imagesUrls(array: [String]) {
    featureds = createFeatureds(with: array)
    delegate?.dataIsReady(status: true)
  }
  
  func error(_ error: String) {
    delegate?.dataError(error: error)
  }
}
