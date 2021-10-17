//
//  ViewController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 10/10/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: IBOUtlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Private methods
    private func initView() {
        addScreenValues()
        addStyleToElements()
    }
    
    private func addScreenValues() {
        emailTextField.placeholder = "Email"
        emailTextField.text = "lrosasarce@gmail.com"
        passwordTextField.placeholder = "Password"
        passwordTextField.text = "espadaulquiorra4"
        
        loginBtn.setTitle("LOG IN", for: .normal)
        signUpBtn.setTitle("Don't have an account? Sign Up", for: .normal)
    }
    
    private func addStyleToElements() {
        loginBtn.addPrimaryStyle()
        signUpBtn.configureAsLink(linkText: "Sign Up")
    }
    
    private func routeToHome() {
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
    
    private func configureActivityIndicator(enabled: Bool) {
        emailTextField.isUserInteractionEnabled = !enabled
        passwordTextField.isUserInteractionEnabled = !enabled
        loginBtn.isUserInteractionEnabled = !enabled
        
        if enabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    

    // MARK: - IBActions
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        configureActivityIndicator(enabled: true)
        APIManager.shared.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginWithUsername(success:error:))
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        redirectToWebSite(urlString: APIManager.Endpoints.signUp.stringValue)
    }
    
    
    
    // MARK: - Handle Response
    private func handleLoginWithUsername(success: Bool, error: Error?) {
        if success {
            APIManager.shared.getUserData(completion: handleUserData(success:error:))
        } else {
            configureActivityIndicator(enabled: false)
            showErrorAlert(message: error?.localizedDescription ?? "")
        }
    }
    
    private func handleUserData(success: Bool, error: Error?) {
        configureActivityIndicator(enabled: false)
        if success {
            emailTextField.text = ""
            passwordTextField.text = ""
            routeToHome()
        } else {
            showErrorAlert(message: error?.localizedDescription ?? "")
        }
    }
}

