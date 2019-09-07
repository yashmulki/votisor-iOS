//
//  MapTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-13.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import MapKit

class VTMapTableViewCell: UITableViewCell {

    @IBOutlet var map: MKMapView!
    var location: CLLocationCoordinate2D!
    
    func configure(location: CLLocationCoordinate2D) {
        self.location = location
        map.setVisibleMapRect(MKMapRect(origin: MKMapPoint(location), size: MKMapSize(width: 2500, height: 2500
        )), animated: true)
        map.setCenter(location, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Your Address"
        annotation.subtitle = "Data is based on this location"
        map.removeAnnotations(map.annotations)
        map.addAnnotation(annotation)
    }
    
    func configureOffice(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                return
            }
            
            self.location = location.coordinate
            self.map.setVisibleMapRect(MKMapRect(origin: MKMapPoint(self.location), size: MKMapSize(width: 2500, height: 2500
            )), animated: true)
            self.map.setCenter(self.location, animated: false)
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.location
            annotation.title = "Office Location"
            annotation.subtitle = address
            self.map.addAnnotation(annotation)
            
        }
    }
    
}
