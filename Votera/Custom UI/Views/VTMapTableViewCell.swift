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
        map.setVisibleMapRect(MKMapRect(origin: MKMapPoint(location), size: MKMapSize(width: 200, height: 200
        )), animated: true)
        map.setCenter(location, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Your Address"
        annotation.subtitle = "Data is based on this location"
        map.addAnnotation(annotation)
    }
    
}
