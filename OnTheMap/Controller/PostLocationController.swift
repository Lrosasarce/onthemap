//
//  PostLocationController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 16/10/21.
//

import UIKit

class PostLocationController: UIViewController {

    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var userLinkLabel: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    
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
        findBtn.setTitle("FIND LOCATION", for: .normal)
    }
    
    private func addStyleToElements() {
        findBtn.addPrimaryStyle()
    }
    
    
    
    
    @IBAction func findBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "findLocation", sender: nil)
    }
    

    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation" {
            if let destination = segue.destination as? LocationResultViewController {
                destination.searchText = locationLabel.text ?? ""
            }
        }
    }

}
