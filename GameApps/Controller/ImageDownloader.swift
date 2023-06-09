//
//  ImageDownloader.swift
//  GameApps
//
//  Created by PLWEP on 30/03/23.
//

import Foundation
import UIKit

class ImageDownloader {
 
  func downloadImage(url: URL) async throws -> UIImage {
    async let imageData: Data = try Data(contentsOf: url)
    return UIImage(data: try await imageData)!
  }
}
