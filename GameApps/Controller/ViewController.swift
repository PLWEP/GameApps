//
//  ViewController.swift
//  GameApps
//
//  Created by PLWEP on 29/03/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gameTableView: UITableView!
    
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() } ()
    
    private var games: [Game] = [] {
        didSet {
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            gameTableView.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameTableView.dataSource = self
        gameTableView.delegate = self
        
        gameTableView.isHidden = true
        loadingIndicator.startAnimating()
        
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {await getGames()}
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
        cell.cellDateLabel.text = game.released ?? "No Information"
        cell.cellRatingLabel.text = "\(game.rating ?? 0.0)"
        cell.isFavorite = game.isFavorite
        
        cell.cellFavoriteButton.tag = indexPath.row
        cell.cellFavoriteButton.addTarget(self, action: #selector(favoriteButtonDidTap(_:)), for: .touchUpInside)
        
        if game.state == .new {
            cell.loadingIndicator.isHidden = false
            cell.loadingIndicator.startAnimating()
            cell.cellImageView.loadRemoteImageFrom(urlString: game.backgroundImage!, loadingIndicator: cell.loadingIndicator)
            game.state = .downloaded
        } else {
            cell.loadingIndicator.stopAnimating()
            cell.loadingIndicator.isHidden = true
        }
       
        cell.loadData()
      return cell
    } else {
      return UITableViewCell()
    }
  }
    
    @objc func favoriteButtonDidTap(_ sender: UIButton) {
        var game = games[sender.tag]
        game.isFavorite = !game.isFavorite
        
        if game.isFavorite {
            favoriteProvider.addFavorite(game.id!, game.name!,  game.released!, game.backgroundImage!, game.rating!, game.isFavorite) {}
        } else {
            favoriteProvider.deleteFavorite(game.id!) {}
        }
   }
}

extension ViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
      performSegue(withIdentifier: "moveToDetail", sender: games[indexPath.row].id)
  }
  override func prepare(
    for segue: UIStoryboardSegue,
    sender: Any?
  ) {
    if segue.identifier == "moveToDetail" {
      if let detaiViewController = segue.destination as? DetailViewController {
          detaiViewController.id = sender as? Int
      }
    }
  }
}
