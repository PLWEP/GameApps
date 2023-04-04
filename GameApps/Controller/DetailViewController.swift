//
//  DetailViewController.swift
//  GameApps
//
//  Created by PLWEP on 30/03/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gameDescLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    @IBOutlet weak var gameRatingLabel: UILabel!
    var id: Int? = nil
    private var game: DetailGameResult? = nil {
        didSet {
            gameImageView.loadRemoteImageFrom(urlString: game?.backgroundImage ?? "", loadingIndicator: imageLoadingIndicator)
            gameTitleLabel.text = game?.name ?? "No Information"
            gameReleasedLabel.text = "Release Date : \(game?.released ?? "No Information")"
            gameRatingLabel.text = "Rating : \(game?.rating ?? 0.0)"
            gameDescLabel.text = game?.description
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToWebsite(_ sender: Any) {
        if let url = URL(string: game?.website ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
          }
    }
    
    @IBAction func goToReddit(_ sender: Any) {
        if let url = URL(string: game?.redditURL ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
          }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {await getDetailGame()}
      }
     
      func getDetailGame() async {
        let network = NetworkService()
        do {
            game = try await network.getDetailGame(id: id!)
        } catch {
          fatalError("Error: connection failed.")
        }
    }
}
