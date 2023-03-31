//
//  NetworkService.swift
//  GameApps
//
//  Created by PLWEP on 30/03/23.
//

import Foundation

class NetworkService {
 
  // MARK: Gunakan API Key.
  let apiKey = "0dd69e63482249fc8b4b9c1d79a2bfbc"
  let pageSize = "20"
 
  func getGames() async throws -> [Game] {
    var components = URLComponents(string: "https://api.rawg.io/api/games")!
    components.queryItems = [
      URLQueryItem(name: "key", value: apiKey),
      URLQueryItem(name: "page_size", value: pageSize)
    ]
    let request = URLRequest(url: components.url!)
 
    let (data, response) = try await URLSession.shared.data(for: request)
 
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      fatalError("Error: Can't fetching data.")
    }
 
    let decoder = JSONDecoder()
    let result = try decoder.decode(APIResult.self, from: data)
 
      return gameMapper(input: result.results!)
  }
    
    func getDetailGame(id: Int) async throws -> DetailGameResult {
      var components = URLComponents(string: "https://api.rawg.io/api/games/\(id)")!
      components.queryItems = [
        URLQueryItem(name: "key", value: apiKey)
      ]
      let request = URLRequest(url: components.url!)
   
      let (data, response) = try await URLSession.shared.data(for: request)
   
      guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        fatalError("Error: Can't fetching data.")
      }
   
      let decoder = JSONDecoder()
      let result = try decoder.decode(DetailGameResult.self, from: data)
   
        return result
    }
}
 
extension NetworkService {
  fileprivate func gameMapper(
    input results: [Game]
  ) -> [Game] {
    return results.map { result in
        return Game(id: result.id, name: result.name, released: result.released, backgroundImage: result.backgroundImage, rating: result.rating, ratingTop: result.ratingTop)
    }
  }
}
