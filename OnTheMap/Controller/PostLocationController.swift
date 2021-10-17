//
//  PostLocationController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 16/10/21.
//

import UIKit

class PostLocationController: UIViewController {

    @IBOutlet weak var studentLocationTextField: UITextField!
    @IBOutlet weak var studentLinkTextField: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    var completionDismiss: (() -> Void)?
    
    var studentInformation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        addScreenValues()
        addStyleToElements()
    }
    
    private func addScreenValues() {
        title = "Add Location"
        studentLocationTextField.text = studentInformation?.mapString ?? ""
        studentLinkTextField.text = studentInformation?.mediaURL ?? ""
        findBtn.setTitle("FIND LOCATION", for: .normal)
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
