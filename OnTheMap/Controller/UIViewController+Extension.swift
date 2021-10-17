//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 11/10/21.
//


import UIKit
extension UIViewController {
    
    func redirectToFailURL(query: String) {
        let urlString = "https://www.google.com/search?q=\(query)"
        let urlSearch = URL(string: urlString)!
        UIApplication.shared.open(urlSearch, completionHandler: nil)
    }
    
    func redirectToWebSite(urlString: String) {
        if let url = URL(string: urlString) {
            
            // Not all students added a correct url format
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, completionHandler: nil)
            } else {
                redirectToFailURL(query: urlString)
            }
            
        } else {
            redirectToFailURL(query: urlString)
        }
    }
    
    func showErrorAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func showErrorAlertOption(message: String, completion: @escaping(() -> Void)) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { _ in
            completion()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
