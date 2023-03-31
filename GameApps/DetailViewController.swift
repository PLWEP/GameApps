//
//  DetailViewController.swift
//  GameApps
//
//  Created by PLWEP on 30/03/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    var id: Int? = nil
    private var game: DetailGameResult? = nil {
        didSet {
            gameImageView.loadRemoteImageFrom(urlString: game?.backgroundImage ?? "", loadingIndicator: imageLoadingIndicator)
            gameTitleLabel.text = game?.name
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
