//
//  SettingsViewController.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 18.03.2023.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    @IBAction func favoriteButton(_ sender: Any) {
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            keyWindow?.rootViewController = loginViewController
        } catch {
            print(error.localizedDescription)
        }
    }
}
