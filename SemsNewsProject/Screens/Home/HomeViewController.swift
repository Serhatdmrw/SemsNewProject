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
        tableViewRegister()
    }
}

// MARK: - Helpers
private extension HomeViewController {
    
    func addDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
    }
    
    func tableViewRegister() {
        self.tableView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellReuseIdentifier: "cell")
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
              let urlString = self.responseModel?.articles[index.row].url,
              let urlToImage = self.responseModel?.articles[index.row].urlToImage,
              let title = self.responseModel?.articles[index.row].title else {
            self.makeLoginAlert(tittleInput: "Error", messegaInput: "Please login.")
            return
        }
        let fireStore = Firestore.firestore().collection("Favorite").document(email)
        guard let fireStoreDictionary = ["url": urlString, "urlToImage": urlToImage, "title": title] as? [String : Any] else { return }
        
        fireStore.collection(userID).document().setData(fireStoreDictionary, merge: true) { error in
            if let error = error {
                self.makeAlert(tittleInput: "Error", messegaInput: error.localizedDescription)
            }
        }
    }
    
    func loadCellImage(url: URL, cell: HomeViewCell) {
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                cell.cellImageView.image = image
            }
        }
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseModel?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeViewCell
        cell.titleLabel.text = responseModel?.articles[indexPath.row].title ?? ""
        let urlToImage = responseModel?.articles[indexPath.row].urlToImage ?? ""
        if let imageUrl = URL(string: urlToImage) {
            loadCellImage(url: imageUrl, cell: cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articlesUrl = self.responseModel?.articles[indexPath.row].url else {
            makeAlert(tittleInput: "Error", messegaInput: "Something went wrong.")
            return
        }
        
        let webViewController = WebViewController()
        webViewController.pageUrl = articlesUrl
        navigationController?.pushViewController(webViewController, animated: true)
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
