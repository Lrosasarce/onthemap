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
    var userLocations = [UserLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.fetchUserLocations { users, Error in
            self.userLocations = users
        }
    }
    
    private func addScreenValues() {
            
    }
    
    private func addStyleToElements() {
        
    }
    
    private func configureMapView() {
        mapView.delegate = self
    }
    
    // MARK: - HandleResponse
    private func handleUserLocation(response: UserLocationResponse?, error:  Error?) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
    }
}
