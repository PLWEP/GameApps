//
//  EditViewController.swift
//  GameApps
//
//  Created by PLWEP on 02/04/23.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveEditProfile(_ sender: Any) {
        if let name = nameTextField.text, let email = emailTextField.text {
            if name.isEmpty {
                textEmpty("Name")
            } else if email.isEmpty {
                textEmpty("Email")
            } else {
                saveProfil(name, email)
                
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func saveProfil(_ name: String, _ email: String) {
        ProfileModel.name = name
        ProfileModel.email = email
    }
        
    func textEmpty(_ field: String) {
        let alert = UIAlertController(
            title: "Alert",
            message: "\(field) is empty",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
