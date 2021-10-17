//
//  ViewController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 10/10/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
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
    

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        APIManager.shared.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginWithUsername(success:error:))
        
    }
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        print(#function)
    }
    
    
    // MARK: - Handle REsponse
    private func handleLoginWithUsername(success: Bool, error: Error?) {
        if success {
            APIManager.shared.getUserData(completion: handleUserData(success:error:))
        } else {
            showErrorAlert(message: error?.localizedDescription ?? "")
        }
    }
    
    private func handleUserData(success: Bool, error: Error?) {
        if success {
            routeToHome()
        } else {
            showErrorAlert(message: error?.localizedDescription ?? "")
        }
    }
}

