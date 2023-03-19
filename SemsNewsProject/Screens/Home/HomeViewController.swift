//
//  HomeViewController.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 16.03.2023.
//

import UIKit
import Lottie
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var responseModel: ResponseModel?
    private let viewModel = HomeViewModel()
    private var animationView = LottieAnimationView(name: "anime")
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAnimationView()
        addDelegates()
        fechService()
        self.tableView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

// MARK: - Helpers
private extension HomeViewController {
    
    func addDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
    }
    
    func fechService() {
        animationView.play()
        animationView.isHidden = false
        viewModel.fechService()
        
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
    
    func saveFirebase(index: IndexPath) {
        guard let userID = Auth.auth().currentUser?.uid,
              let email = Auth.auth().currentUser?.email,
              let urlString = self.responseModel?.articles[index.row].url else { return }
        let fireStore = Firestore.firestore().collection("Favorite").document(email)
        guard let fireStoreDictionary = ["url": urlString] as? [String : Any] else { return }
        
        fireStore.collection(userID).document().setData(fireStoreDictionary, merge: true) { error in
            if let error = error {
                self.makeAlert(tittleInput: "Error", messegaInput: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseModel?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeViewCell
        cell.titleLabel.text = responseModel?.articles[indexPath.row].title ?? ""
        let publishedAt = responseModel?.articles[indexPath.row].publishedAt ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: publishedAt) ?? Date()
        dateFormatter.dateFormat = "dd-MM-yyyy' - 'HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articlesUrl = self.responseModel?.articles[indexPath.row].url else {
            makeAlert(tittleInput: "Error", messegaInput: "Bir hata oluştu.")
            return
        }
        
        if let url = URL(string: articlesUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title:  "Add Favorites", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.saveFirebase(index: indexPath)
            success(true)
        })
        favoriteAction.image = UIImage(named: "favoriteIcon")
        favoriteAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    
    func didFetchServiceSuccess(responseModel: ResponseModel) {
        self.responseModel = responseModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.animationView.stop()
            self.animationView.isHidden = true
        }
    }
    
    func didFetchServiceFail(message: String) {
        makeAlert(tittleInput: "Error", messegaInput: message)
        self.animationView.stop()
        self.animationView.isHidden = true
    }
}
