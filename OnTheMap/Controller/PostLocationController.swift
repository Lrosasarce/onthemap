//
//  PostLocationController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 16/10/21.
//

import UIKit

class PostLocationController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var studentLocationTextField: UITextField!
    @IBOutlet weak var studentLinkTextField: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    
    // MARK: - Properties
    var completionDismiss: (() -> Void)?
    var studentInformation: StudentInformation?
    
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
        title = "Add Location"
        studentLocationTextField.delegate = self
        studentLocationTextField.text = studentInformation?.mapString ?? ""
        studentLinkTextField.text = studentInformation?.mediaURL ?? ""
        studentLinkTextField.delegate = self
        findBtn.setTitle("FIND LOCATION", for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addStyleToElements() {
        findBtn.addPrimaryStyle()
    }
    
    private func validateForm() -> Bool{
        if !studentLocationTextField.hasText {
            showErrorAlert(message: "Please enter a valid Location")
            return false
        }
        
        guard let studentLink = URL(string: studentLinkTextField.text!) else {
            showErrorAlert(message: "Please enter a valid mediaURL")
            return false
        }
        
        if UIApplication.shared.canOpenURL(studentLink) == false {
            showErrorAlert(message: "Please enter a valid mediaURL")
            return false
        }
        
        return true
    }
    
    
    // MARK: - IBAction
    @IBAction func findBtnPressed(_ sender: UIButton) {
        if validateForm() {
            performSegue(withIdentifier: "findLocation", sender: nil)
        }
    }
    

    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation" {
            if let destination = segue.destination as? LocationResultViewController {
                destination.searchText = studentLocationTextField.text ?? ""
                destination.mediaURLString = studentLinkTextField.text ?? ""
                destination.studentPostedLocation = studentInformation != nil
                destination.completionDismiss = completionDismiss
            }
        }
    }

}

// MARK: - UITextFieldDelegate
extension PostLocationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
