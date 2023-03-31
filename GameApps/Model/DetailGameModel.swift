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
    let updated: String?
    let backgroundImage: String?
    let website: String?
    let rating: Double?
    let ratingTop: Int?
    let redditURL: String?
    let developers, genres, tags, publishers: [Developer]?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case released, updated
        case backgroundImage = "background_image"
        case website, rating
        case ratingTop = "rating_top"
        case redditURL = "reddit_url"
        case developers, genres, tags, publishers
    }
    
    init(id: Int?, name: String?, description: String?, released: String?, updated: String?, backgroundImage: String?, website: String?, rating: Double?, ratingTop: Int?, redditURL: String?, developers: [Developer]?, genres: [Developer]?, tags: [Developer]?, publishers: [Developer]?) {
        self.id = id
        self.name = name
        self.description = description
        self.released = released
        self.updated = updated
        self.backgroundImage = backgroundImage
        self.website = website
        self.rating = rating
        self.ratingTop = ratingTop
        self.redditURL = redditURL
        self.developers = developers
        self.genres = genres
        self.tags = tags
        self.publishers = publishers
    }
}

// MARK: - Developer
struct Developer : Codable {
    let id: Int?
    let name: String?
    let gamesCount: Int?
    let imageBackground: String?
    let domain: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case domain
    }
    
    init(id: Int?, name: String?, gamesCount: Int?, imageBackground: String?, domain: String?) {
        self.id = id
        self.name = name
        self.gamesCount = gamesCount
        self.imageBackground = imageBackground
        self.domain = domain
    }
}


