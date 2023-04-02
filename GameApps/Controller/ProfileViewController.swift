//
//  ProfileViewController.swift
//  GameApps
//
//  Created by PLWEP on 02/04/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailProfileLabel: UILabel!
    @IBOutlet weak var nameProfileLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moveToEdit(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToEdit", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProfileModel.synchronize()
        nameProfileLabel.text = "Nama : \(ProfileModel.name)"
        emailProfileLabel.text = "Email : \(ProfileModel.email)"
    }
}
