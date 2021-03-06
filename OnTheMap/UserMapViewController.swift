//
//  UserMapViewController.swift
//  OnTheMap
//
//  Created by Haoran Li on 2020-09-12.
//  Copyright © 2020 Haoran Li. All rights reserved.
//

import UIKit
import MapKit

class UserMapViewController: UserViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.addAnnotations(self.userLocations.map{self.generatePin(locationInfo: $0)})
        self.mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let markerAnnotationView: MKMarkerAnnotationView
//        let markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let identifier = "location"
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            markerAnnotationView = dequeuedView
        } else {
            markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return markerAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let temp = view.annotation?.subtitle, var stringURL = temp {
            if (!stringURL.starts(with: "https://")){
                stringURL = "https://" + stringURL
            }
            if let url = URL(string: stringURL){
                UIApplication.shared.open(url) {
                    success in
                    if !success {
                        self.showInvalidURLWarning(message: stringURL) // showing alert as new page
                    }
                }
            } else {
                self.showInvalidURLWarning(message: stringURL) // showing alert as new page
            }
        }
        
    }
    
    func generatePin(locationInfo: UserLocation) -> MKPointAnnotation{
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: Double(locationInfo.latitude), longitude: Double(locationInfo.longitude))
        if (locationInfo.firstName == "" && locationInfo.lastName == ""){
            pin.title = "<No name given>"
        } else {
            pin.title = (locationInfo.firstName + " " + locationInfo.lastName)
        }
        if (locationInfo.mediaURL == ""){
            pin.subtitle = "<No URL given>"
        } else {
            pin.subtitle = locationInfo.mediaURL
        }
        return pin
    }
    
    
    @IBAction override func logout(_ sender: Any) {
        super.logout(sender)
    }
    
    @IBAction override func addLocation(_ sender: Any) {
        super.addLocation(sender)
    }
    
    @IBAction override func refresh(_ sender: Any) {
        super.refresh(sender)
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotations(self.userLocations.map{self.generatePin(locationInfo: $0)})
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
