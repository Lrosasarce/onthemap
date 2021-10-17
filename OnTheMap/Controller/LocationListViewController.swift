//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 11/10/21.
//

import UIKit

class LocationListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var userLocations: [StudentInformation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.userLocations
    }
    var studentInformation: StudentInformation?

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Private methods
    private func initView() {
        addScreenValues()
        configureTableView()
    }
    
    private func addScreenValues() {
        title = "On the Map"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchLocations() {
        configureActivityIndicator(enabled: true)
        APIManager.shared.fetchUserLocations(completion: handleUserLocation(locations:error:))
    }
    
    private func configureActivityIndicator(enabled: Bool) {
        tableView.isUserInteractionEnabled = !enabled
        if enabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - HandleResponse
    private func handleUserLocation(locations: [StudentInformation], error:  Error?) {
        
        if let error = error {
            showErrorAlert(message: error.localizedDescription)
            return
        }
        
        configureActivityIndicator(enabled: false)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.userLocations = locations
        
        tableView.reloadData()
    }
    
    // MARK: - IBAction
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAnnotationBtnPressed(_ sender: UIBarButtonItem) {
        if let location = userLocations.filter({ $0.objectId == APIManager.Auth.objectId }).first {
            studentInformation = location
            showErrorAlertOption(message: "You Have Already Posted a Student Location, Would you like Overwrite Your Current Location?") {
                APIManager.Auth.objectId = self.studentInformation?.objectId ?? ""
                self.performSegue(withIdentifier: "addPost", sender: nil)
            }
        } else {
            self.performSegue(withIdentifier: "addPost", sender: nil)
        }
    }
    
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        fetchLocations()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPost" {
            if let navigation = segue.destination as? UINavigationController, let destination = navigation.viewControllers.first as? PostLocationController {
                destination.studentInformation = studentInformation
                destination.completionDismiss = fetchLocations
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userLocations[indexPath.row].getFormatName()
        cell.detailTextLabel?.text = userLocations[indexPath.row].mediaURL
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        redirectToWebSite(urlString: userLocations[indexPath.row].mediaURL)
    }
}
