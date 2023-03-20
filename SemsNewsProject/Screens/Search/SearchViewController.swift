//
//  SearchViewController.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 18.03.2023.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var searchText: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var textFieldSubView: UIView!
    
    // MARK: - Properties
    private var responseModel: ResponseModel?
    private let searcViewModel = SearcViewModel()
    private var animationView = LottieAnimationView(name: "anime")


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestureRecognizer()
        setProperties()
        setAnimationView()
        tableViewRegister()
        addDelegates()
    }
    
    // MARK: - Actions
    @IBAction func searchButton(_ sender: Any) {
        animationView.play()
        animationView.isHidden = false
        searcViewModel.fechService(searchText: searchText.text)
    }
}

// MARK: - Helpers
private extension SearchViewController {
    
    func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func setProperties() {
        textFieldSubView.layer.cornerRadius = 12
        searchButton.layer.cornerRadius = 12
    }
    
    func setAnimationView() {
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.isHidden = true
        view.addSubview(animationView)
    }

    func addDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        searcViewModel.delegate = self
    }
    
    func makeAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func tableViewRegister() {
        self.tableView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellReuseIdentifier: "cell")
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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
            makeAlert(tittleInput: "Error", messegaInput: "Bir hata oluştu.")
            return
        }
        
        if let url = URL(string: articlesUrl) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - SearchViewModelDelegate
extension SearchViewController: SearcViewModelDelegate {
    func didFetchServiceSuccess(responseModel: ResponseModel) {
        self.responseModel = responseModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.animationView.stop()
            self.animationView.isHidden = true
        }
    }
    
    func didFetchServiceFail(message: String) {
        self.makeAlert(tittleInput: "Error", messegaInput: "Üzgünüz bir hata oluştu")
        self.animationView.stop()
        self.animationView.isHidden = true
    }
}
