//
//  Extension.swift
//  GameApps
//
//  Created by PLWEP on 02/04/23.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadRemoteImageFrom(urlString: String, loadingIndicator: UIActivityIndicatorView){
      guard let url = URL(string: urlString) else {return }
    image = nil
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = imageFromCache
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        return
    }
    URLSession.shared.dataTask(with: url) {
        data, response, error in
        DispatchQueue.main.async {
                    loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
                }
          if let response = data {
              DispatchQueue.main.async {
                if let imageToCache = UIImage(data: response) {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }else{
                    self.image = UIImage(named: "no image")
                }
              }
          }
     }.resume()
  }
}
