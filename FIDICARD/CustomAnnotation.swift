//
//  CustomAnnotation.swift
//  FIDICARD
//
//  Created by Martin Viruete Gonzalez on 07/10/16.
//  Copyright © 2016 oomovil. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject,MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    

}
