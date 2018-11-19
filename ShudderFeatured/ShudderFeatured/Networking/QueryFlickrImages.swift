//
//  QueryFlickrImage.swift
//  ShudderFeatured
//
//  Created by YAUHENI IVANIUK on 11/1/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

protocol QueryFlickrImagesProtocol {
  func imagesUrls(array: [String])
  func error(_ error: String)
}

fileprivate struct FlickrRespons: Codable {
  let photos: Image
  
  struct Image: Codable {
    let photo: [UrlM]
  }
  
  struct UrlM: Codable {
    let urlM: String
    enum CodingKeys : String, CodingKey {
      case urlM = "url_m"
    }
  }
}

class QueryFlickrImages {
  
  var delegate: QueryFlickrImagesProtocol?
  
  init() {
    geArrauOfUrls()
  }
  
  func dowloadImageFor(url: String, completionHandler: @escaping (_ image: UIImage?)-> () ) {
    DispatchQueue.global().async {
      guard let url = URL(string: url) else { return }
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            completionHandler(image)
          }
        }
      }
    }
  }
  
  private func geArrauOfUrls() {
    getArrayOfPfotoString { [weak self] (urls, error) in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        if let urls = urls {
          self.delegate?.imagesUrls(array: urls)
        }
        if let error = error {
          self.delegate?.error(error)
        }
      }
    }
  }
  
  private func getArrayOfPfotoString(completionHandler: @escaping (_ imageUrls: [String]?, _ error: String?)-> () ) {
    let session = URLSession.shared
    let request = URLRequest(url: flickrURLFromParameters())
    
    session.dataTask(with: request) { (data, response, error) in
      
      guard error == nil else {
        completionHandler(nil, error.debugDescription)
        print("There was an error with request: \(error.debugDescription)")
        return
      }
      guard let data = data else {
        print("No data was returned by the request!")
        return
      }
      
      let decoder = JSONDecoder()
      do {
        let imagesUrls = try decoder.decode(FlickrRespons.self, from: data)
        let imagesUrlArray = imagesUrls.photos.photo.map( { $0.urlM })
        completionHandler(imagesUrlArray, nil)
      }
      catch {
        completionHandler(nil, error.localizedDescription)
        print("Error with decod.")
      }
      
      }.resume()
  }
  
  
  private func flickrURLFromParameters() -> URL {
    
    let methodParameters = [
      FlickrUrl.FlickrParameterKeys.Method: FlickrUrl.FlickrParameterValues.SearchMethod,
      FlickrUrl.FlickrParameterKeys.APIKey: FlickrUrl.FlickrParameterValues.APIKey,
      FlickrUrl.FlickrParameterKeys.Text: FlickrUrl.FlickrParameterValues.Text,
      FlickrUrl.FlickrParameterKeys.SafeSearch: FlickrUrl.FlickrParameterValues.UseSafeSearch,
      FlickrUrl.FlickrParameterKeys.Extras: FlickrUrl.FlickrParameterValues.MediumURL,
      FlickrUrl.FlickrParameterKeys.Format: FlickrUrl.FlickrParameterValues.ResponseFormat,
      FlickrUrl.FlickrParameterKeys.NoJSONCallback: FlickrUrl.FlickrParameterValues.DisableJSONCallback,
      FlickrUrl.FlickrParameterKeys.Sort: FlickrUrl.FlickrParameterValues.Relevance
    ]
    
    var components = URLComponents()
    components.scheme = FlickrUrl.Flickr.APIScheme
    components.host = FlickrUrl.Flickr.APIHost
    components.path = FlickrUrl.Flickr.APIPath
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in methodParameters {
      let queryItem = URLQueryItem(name: key, value: "\(value)")
      components.queryItems!.append(queryItem)
    }
    
    return components.url!
  }
}
