//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 11/10/21.
//

import UIKit

class LocationListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userLocations: [UserLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.userLocations
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        addScreenValues()
        addStyleToElements()
        configureTableView()
    }
    
    private func addScreenValues() {
        
    }
    
    private func addStyleToElements() {
        
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
    private func handleUserLocation(locations: [UserLocation], error:  Error?) {
        
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
        print(#function)
    }
    
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        fetchLocations()
    }
}

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

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        redirectToWebSite(urlString: userLocations[indexPath.row].mediaURL)
    }
}
