//
//  DetailGameModel.swift
//  GameApps
//
//  Created by PLWEP on 30/03/23.
//

import Foundation

// MARK: - APIResult
struct DetailGameResult: Codable {
    let id: Int?
    let name, description: String?
    let released: String?
    let backgroundImage: String?
    let website: String?
    let rating: Double?
    let redditURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case description = "description_raw"
        case released
        case backgroundImage = "background_image"
        case website, rating
        case redditURL = "reddit_url"
    }
    
    init(id: Int?, name: String?, description: String?, released: String?, backgroundImage: String?, website: String?, rating: Double?, redditURL: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.released = released
        self.backgroundImage = backgroundImage
        self.website = website
        self.rating = rating
        self.redditURL = redditURL
    }
}


