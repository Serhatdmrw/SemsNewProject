//
//  LoginViewController.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 14.03.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Outles
    @IBOutlet private weak var emailText: UITextField!
    @IBOutlet private weak var passwordText: UITextField!
    @IBOutlet private weak var textFieldSubView: UIView!
    @IBOutlet private weak var passswordSubView: UIView!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestureRecognizer()
        addDelegates()
        setProperties()
    }
    
    // MARK: - Actions
    @IBAction func didTapSignInButton(_ sender: Any) {
        
        guard let email = emailText.text, let password = passwordText.text else {
            makeAlert(tittleInput: "ERROR", messegaInput: "Please check your login information.")
            return
        }
        
        viewModel.signIn(email: email, password: password)
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
      
        guard let email = emailText.text, let password = passwordText.text else {
            makeAlert(tittleInput: "Error", messegaInput: "Please enter a valid email or password.")
            return
        }
        
        viewModel.createUser(email: email, password: password)
    }
}

// MARK: - Helpers
private extension LoginViewController {
    
    func makeAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func addDelegates() {
        viewModel.delegate = self
    }
    
    func setProperties() {
        textFieldSubView.layer.cornerRadius = 12
        passswordSubView.layer.cornerRadius = 12
        signInButton.layer.cornerRadius = 24
        signUpButton.layer.cornerRadius = 24
    }
    
    func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    
    func didSignInSuccess() {
        let tabbarViewController = TabbarViewController(nibName: "TabbarViewController", bundle: nil)
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        keyWindow?.rootViewController = tabbarViewController
    }
    
    func didSignInFail(message: String) {
        makeAlert(tittleInput: "Error", messegaInput: message)
    }
    
    func didCreateSuccess() {
        makeAlert(tittleInput: "Success", messegaInput: "Congratulations, your registration has been successfully done. You can login.")
    }
    
    func didCreateFail(message: String) {
        makeAlert(tittleInput: "Error", messegaInput: message)
    }
}
