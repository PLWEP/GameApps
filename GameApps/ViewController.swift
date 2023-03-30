//
//  ViewController.swift
//  GameApps
//
//  Created by PLWEP on 29/03/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameTableView: UITableView!
    
    private var games: [Game] = [] 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameTableView.dataSource = self
        
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await getGames() }
      }
     
      func getGames() async {
        let network = NetworkService()
        do {
          games = try await network.getGames()
          gameTableView.reloadData()
        } catch {
          fatalError("Error: connection failed.")
        }
      }
}

extension ViewController: UITableViewDataSource {
 
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
     return games.count
  }
    
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: "gameTableViewCell",
      for: indexPath
    ) as? GameTableViewCell {
        var game = games[indexPath.row]
        cell.cellTitleLabel.text = game.name ?? "No Information"
        cell.cellDateLabel.text = "Release Date : \(game.released ?? "No Information")"
        cell.cellRatingLabel.text = "Rating : \(game.rating ?? 0.0)"
        
        if game.state == .new {
            cell.loadingIndicator.isHidden = false
            cell.loadingIndicator.startAnimating()
            cell.cellImageView.loadRemoteImageFrom(urlString: game.backgroundImage!, loadingIndicator: cell.loadingIndicator)
            game.state = .downloaded
      } else {
            cell.loadingIndicator.stopAnimating()
            cell.loadingIndicator.isHidden = true
        }
        
      return cell
    } else {
      return UITableViewCell()
    }
  }
}

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
