//
//  GameModel.swift
//  GameApps
//
//  Created by PLWEP on 30/03/23.
//

import Foundation

enum DownloadState {
    case new, downloaded
}

// MARK: - APIResult
struct APIResult: Codable {
    let count: Int?
    let next: String?
    let results: [Game]?

    enum CodingKeys: String, CodingKey {
        case count, next, results
    }
    
    init(count: Int?, next: String?, results: [Game]?) {
        self.count = count
        self.next = next
        self.results = results
    }
}

// MARK: - Result
struct Game: Codable {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    
    var state: DownloadState = .new
    var isFavorite : Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
    }
    
    init(id: Int?, name: String?, released: String?, backgroundImage: String?, rating: Double?) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
    }
    
    init(id: Int?, name: String?, released: String?, backgroundImage: String?, rating: Double?, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.isFavorite = isFavorite
    }
}
