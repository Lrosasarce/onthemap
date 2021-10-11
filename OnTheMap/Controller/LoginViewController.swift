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
        passwordTextField.placeholder = "Password"
        
        loginBtn.setTitle("LOG IN", for: .normal)
        signUpBtn.setTitle("Don't have an account? Sign Up", for: .normal)
    }
    
    private func addStyleToElements() {
        loginBtn.addPrimaryStyle()
        signUpBtn.configureAsLink(linkText: "Sign Up")
    }
    


}

