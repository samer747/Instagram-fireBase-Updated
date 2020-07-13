//
//  CustomImageView.swift
//  Instagram Firebase
//
//  Created by Vyacheslav Nagornyak on 4/15/17.
//  Copyright © 2017 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
  
  // MARK: - Variables
  var lastUrlUsed: String?
  
  // MARK: - Functions
  func loadImage(url urlString: String) {
    
    image = nil
    
    lastUrlUsed = urlString
    
    if let cachedImage = imageCache[urlString] {
      image = cachedImage
      return
    }
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
      if let error = error {
        print("Failed to load image from db:", error)
        return
      }
      
        if url.absoluteString != self?.lastUrlUsed {
        return
      }
      
      guard let imageData = data else { return }
      
      let photoImage = UIImage(data: imageData)
      imageCache[url.absoluteString] = photoImage
      
      DispatchQueue.main.async {
        self?.image = photoImage
      }
    }.resume()
  }
}
