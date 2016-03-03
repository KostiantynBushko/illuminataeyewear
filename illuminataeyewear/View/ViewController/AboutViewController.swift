//
//  AboutViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 2/18/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import MapKit


class AboutViewController: UIViewController {
    
    @IBOutlet var mapKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        
        var coordinateRegion = MKCoordinateRegion()
        coordinateRegion.center.latitude = 43.615001
        coordinateRegion.center.longitude = -79.557379
        coordinateRegion.span.latitudeDelta = 0.01
        coordinateRegion.span.longitudeDelta = 0.01
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinateRegion.center
        annotation.title = "Illuminata Eyewear"
        
        mapKit.setRegion(coordinateRegion, animated: true)
        mapKit.addAnnotation(annotation)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
