//
//  LocationResultViewController.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 16/10/21.
//

import UIKit
import MapKit

class LocationResultViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishBtn: UIButton!
    
    var searchText: String = ""
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
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
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription)")
                self.showErrorAlert(message: "Sorry, the location could not be found.")
                return
            }
            
            for item in response.mapItems {
                if let _ = item.name,
                    let locationResponse = item.placemark.location {
                    self.location = locationResponse.coordinate
                    self.searchLocation(location: self.location!)
                }
            }
        }
    }
    
    func searchLocation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = searchText
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        mapView.addAnnotation(annotation)
        mapView.setCenter(location, animated: false)
    }

    @IBAction func finishBtnPressed(_ sender: UIButton) {
        guard let location = location else {
            self.showErrorAlert(message: "Sorry, the location could not be found.")
            return
        }

    }

}

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
