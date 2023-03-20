//
//  SettingsViewController.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 18.03.2023.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // MARK: - Outles
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
    }
    
    // MARK: - Actions
    @IBAction func favoriteButton(_ sender: Any) {
        navigationController?.pushViewController(FavoriteViewController(), animated: true)
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            keyWindow?.rootViewController = loginViewController
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Helpers
private extension SettingsViewController {
    func setProperties() {
        favoriteButton.layer.cornerRadius = 12
        logoutButton.layer.cornerRadius = 12
    }
}
