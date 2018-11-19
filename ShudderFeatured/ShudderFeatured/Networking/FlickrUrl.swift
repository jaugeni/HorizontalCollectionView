//
//  FlickrUrl.swift
//  ShudderFeatured
//
//  Created by YAUHENI IVANIUK on 11/1/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import Foundation

struct FlickrUrl {
  
  // MARK: Flickr
  struct Flickr {
    static let APIScheme = "https"
    static let APIHost = "api.flickr.com"
    static let APIPath = "/services/rest"
  }
  
  // MARK: Flickr Parameter Keys
  struct FlickrParameterKeys {
    static let Method = "method"
    static let APIKey = "api_key"
    static let Text = "text"
    static let SafeSearch = "safe_search"
    static let Extras = "extras"
    static let Format = "format"
    static let NoJSONCallback = "nojsoncallback"
    static let Sort = "sort"
  }
  
  // MARK: Flickr Parameter Values
  struct FlickrParameterValues {
    static let SearchMethod = "flickr.photos.search"
    #warning ("Your API Key")
    static let APIKey = "YOR API KEY"
    static let Text = "horror movie posters"
    static let UseSafeSearch = "1"
    static let MediumURL = "url_m"
    static let ResponseFormat = "json"
    static let DisableJSONCallback = "1"
    static let Relevance = "relevance"
  }
}
