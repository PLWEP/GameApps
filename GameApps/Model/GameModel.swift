//
//  GameModel.swift
//  GameApps
//
//  Created by PLWEP on 30/03/23.
//

import Foundation
import UIKit

enum DownloadState {
    case new, downloaded
}

// MARK: - APIResult
struct APIResult: Codable {
    let count: Int?
    let next: String?
    let results: [GameResult]?

    enum CodingKeys: String, CodingKey {
        case count, next, results
    }
    
    init(count: Int?, next: String?, results: [GameResult]?) {
        self.count = count
        self.next = next
        self.results = results
    }
}

// MARK: - Result
struct GameResult: Codable {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.backgroundImage = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        self.ratingTop = try container.decodeIfPresent(Int.self, forKey: .ratingTop)
        self.released = try container.decodeIfPresent(String.self, forKey: .released)
    }
}

// MARK: - Game
struct Game {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    
    var state: DownloadState = .new

    init(id: Int?, name: String?, released: String?, backgroundImage: String?, rating: Double?, ratingTop: Int?) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingTop = ratingTop
    }
}
