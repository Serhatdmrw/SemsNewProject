//
//  SearchViewController.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 18.03.2023.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var searchText: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private var responseModel: Welcome?
    private let searcViewModel = SearcViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewRegister()
        addDelegates()
    }
    
    // MARK: - Actions
    @IBAction func searchButton(_ sender: Any) {
        searcViewModel.fechService(searchText: searchText.text)
    }
}

// MARK: - Helpers
private extension SearchViewController {
    
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
        self.tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseModel?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        cell.titleLabel.text = responseModel?.articles[indexPath.row].title ?? ""
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
    func didFetchServiceSuccess(responseModel: Welcome) {
        self.responseModel = responseModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFetchServiceFail(message: String) {
        self.makeAlert(tittleInput: "Error", messegaInput: "Üzgünüz bir hata oluştu")
    }
}
