//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 10/10/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var annotations: [MKPointAnnotation] = []
    
    var userLocations: [StudentInformation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.userLocations
    }
    var userLocation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        fetchLocations()
    }
    
    private func initView() {
        addScreenValues()
        addStyleToElements()
        configureMapView()
        
    }
    
    private func addScreenValues() {
        title = "On the Map"
    }
    
    private func addStyleToElements() {
        
    }
    
    private func configureMapView() {
        mapView.delegate = self
    }
    
    private func fetchLocations() {
        configureActivityIndicator(enabled: true)
        APIManager.shared.fetchUserLocations(completion: handleUserLocation(locations:error:))
    }
    
    private func configureActivityIndicator(enabled: Bool) {
        mapView.isUserInteractionEnabled = !enabled
        if enabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - HandleResponse
    private func handleUserLocation(locations: [StudentInformation], error:  Error?) {
        configureActivityIndicator(enabled: false)
        
        if let error = error {
            showErrorAlert(message: error.localizedDescription)
            return
        }
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.userLocations = locations
        
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.getFormatName()
            annotation.subtitle = location.mediaURL
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
        
    }
    
    // MARK: - IBAction
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        APIManager.shared.logout {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addAnnotationBtnPressed(_ sender: UIBarButtonItem) {
        if let location = userLocations.filter({ $0.objectId == "c536a94j8654psprbc50" }).first {
            userLocation = location
            showErrorAlertOption(message: "You Have Already Posted a Student Location, Would you like Overwrite Your Current Location?") {
                self.performSegue(withIdentifier: "addPost", sender: nil)
            }
        }
    }
    
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        fetchLocations()
    }
    
    // MARK: - Class method
    class func instanceViewController() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "MapViewController") as? MapViewController else {
            return MapViewController()
        }
        return viewController
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation")
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        redirectToWebSite(urlString: annotation.subtitle ?? "")
    }
    
}
