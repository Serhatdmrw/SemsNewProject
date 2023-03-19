//
//  FavoriteViewController.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 18.03.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase
import Lottie

class FavoriteViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var firebaseModels: [FirebaseModel] = []
    private let favoriteviewModel = FavoriteViewModel()
    private var animationView = LottieAnimationView(name: "anime")

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAnimationView()
        addDelegates()
        tableViewRegister()
        getFavorite()
    }
}

// MARK: - Helpers
private extension FavoriteViewController {
    
    func getFavorite() {
        animationView.play()
        animationView.isHidden = false
        favoriteviewModel.getData()
    }
    
    func setAnimationView() {
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.isHidden = true
        view.addSubview(animationView)
    }

    func makeAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func addDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        favoriteviewModel.delegate = self
    }
    
    func tableViewRegister() {
        self.tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoritecelll")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.firebaseModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritecelll", for: indexPath) as! FavoriteTableViewCell
        cell.favoriteLabel.text = self.firebaseModels[indexPath.row].url
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firebaseModelsUrl = self.firebaseModels[indexPath.row].url
        if let url = URL(string: firebaseModelsUrl) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - FavoriteViewModelDelegate
extension FavoriteViewController : FavoriteViewModelDelegate {
    
    func favoriteSuccess(firebaseModels: [FirebaseModel]) {
        self.firebaseModels = firebaseModels
        self.tableView.reloadData()
        self.animationView.stop()
        self.animationView.isHidden = true
    }
    
    func favoriteFail(message: String) {
        self.makeAlert(tittleInput: "Error", messegaInput: message)
        self.animationView.stop()
        self.animationView.isHidden = true
    }
}
