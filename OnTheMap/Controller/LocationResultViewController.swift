//
//  LocationResultViewController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 16/10/21.
//

import UIKit
import MapKit

class LocationResultViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var searchText: String = ""
    var mediaURLString: String = ""
    var studentPostedLocation: Bool = false
    var location: CLLocationCoordinate2D?
    var completionDismiss: (() -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Private methods
    private func initView() {
        addScreenValues()
        addStyleToElements()
        searchLocation()
    }
    
    private func addScreenValues() {
        title = "Add Location"
        finishBtn.setTitle("FINISH", for: .normal)
    }
    
    private func addStyleToElements() {
        finishBtn.addPrimaryStyle()
        mapView.delegate = self
    }
    
    private func searchLocation() {
        configureActivityIndicator(enabled: true)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error!.localizedDescription)")
                self.showErrorAlert(message: "Sorry, the location could not be found.")
                return
            }
            
            for item in response.mapItems {
                if let _ = item.name, let locationResponse = item.placemark.location {
                    self.location = locationResponse.coordinate
                    self.searchLocation(location: self.location!)
                    break
                }
            }
        }
    }
    
    func searchLocation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = searchText
        annotation.coordinate = location
        let region = MKCoordinateRegion(center: location
                                        , latitudinalMeters: 500, longitudinalMeters: 500)
        let adjustRegion = mapView.regionThatFits(region)
        mapView.addAnnotation(annotation)
        mapView.setCenter(location, animated: true)
        mapView.setRegion(adjustRegion, animated: true)
        configureActivityIndicator(enabled: false)
    }
    
    private func configureActivityIndicator(enabled: Bool) {
        finishBtn.isUserInteractionEnabled = !enabled
        enabled ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
    }

    // MARK: - IBAction
    @IBAction func finishBtnPressed(_ sender: UIButton) {
        guard let location = location else {
            self.showErrorAlert(message: "Sorry, the location could not be found.")
            return
        }
        
        configureActivityIndicator(enabled: true)
        finishBtn.isUserInteractionEnabled = false
        if studentPostedLocation {
            APIManager.shared.updateStudentLocation(mapString: searchText, mediaURL: mediaURLString, latitude: location.latitude, longitude: location.longitude, completion: handleLocationSaved(success:error:))
        } else {
            APIManager.shared.postStudentLocation(mapString: searchText, mediaURL: mediaURLString, latitude: location.latitude, longitude: location.longitude, completion: handleLocationSaved(success:error:))
        }

    }
    
    // MARK: - Handle Response
    private func handleLocationSaved(success: Bool, error: Error?) {
        configureActivityIndicator(enabled: false)
        if success {
            completionDismiss?()
            dismiss(animated: true, completion: nil)
            
        } else {
            showErrorAlert(message: error!.localizedDescription)
        }
    }

    
}

// MARK: - MKMapViewDelegate
extension LocationResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation")
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}
