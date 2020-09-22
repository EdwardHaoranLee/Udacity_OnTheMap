//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Haoran Li on 2020-09-22.
//  Copyright © 2020 Haoran Li. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController{
    
    var locationString: String!
    @IBOutlet weak var mapView: MKMapView!
    var addLocationVC: AddLocationViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchLocation()
    }
    
    func searchLocation(){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationString
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                let alertVC = UIAlertController(title: "Location not found.", message: "Please input another location.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            
            let pin = MKPointAnnotation()
            pin.coordinate = response.mapItems[0].placemark.coordinate
            pin.title = response.mapItems[0].name
            self.mapView.addAnnotation(pin)
        }
    }
    
}