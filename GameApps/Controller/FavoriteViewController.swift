//
//  FavoriteViewController.swift
//  GameApps
//
//  Created by PLWEP on 02/04/23.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() } ()
    
    private var favorite: [Game] = [] {
        didSet {
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            favoriteTableView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
        favoriteTableView.isHidden = true
        loadingIndicator.startAnimating()
        
        favoriteTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        self.favoriteProvider.getAllFavorite() { result in
            DispatchQueue.main.async {
                self.favorite = result
                self.favoriteTableView.reloadData()
            }
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
 
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
     return favorite.count
  }
    
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: "gameTableViewCell",
      for: indexPath
    ) as? GameTableViewCell {
        var game = favorite[indexPath.row]
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
        var game = favorite[sender.tag]
        game.isFavorite = !game.isFavorite
        
        if game.isFavorite {
            favoriteProvider.addFavorite(game.id!, game.name!,  game.released!, game.backgroundImage!, game.rating!, game.isFavorite) {
                self.loadData()
            }
        } else {
            favoriteProvider.deleteFavorite(game.id!) {
                self.loadData()
            }
        }
   }
}

extension FavoriteViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
      performSegue(withIdentifier: "moveToDetail", sender: favorite[indexPath.row].id)
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

