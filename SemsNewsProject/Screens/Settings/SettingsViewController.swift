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
    @IBOutlet weak var removeButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
    }
    
    // MARK: - Actions
    @IBAction func favoriteButton(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            self.makeLoginAlert(tittleInput: "Error", messegaInput: "Please login.")
            return
        }
        
        navigationController?.pushViewController(FavoriteViewController(), animated: true)
    }
    
    @IBAction func removeAccountButton(_ sender: Any) {
        Auth.auth().currentUser?.delete(completion: { error in
            if error == nil {
                let storyboard = UIStoryboard(name: "Login", bundle: .main)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
                let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
                keyWindow?.rootViewController = loginViewController
            }
        })
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
        removeButton.layer.cornerRadius = 12
    }
    
    func makeLoginAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let loginButton = UIAlertAction(title: "Login", style: UIAlertAction.Style.default) { _ in
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! UINavigationController
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            keyWindow?.rootViewController = loginViewController
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        alert.addAction(loginButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
}
