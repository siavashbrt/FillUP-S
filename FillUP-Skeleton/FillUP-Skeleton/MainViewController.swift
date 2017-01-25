//
//  MainViewController.swift
//  FillUP-Skeleton
//
//  Created by Kiarash Teymoury on 1/8/17.
//  Copyright © 2017 Siavash Baratchi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {

    //  to get and manage user current location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .blue
        print("Home")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let UserCurrentLocationCoordinates = locationManager.location?.coordinate
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: UserCurrentLocationCoordinates!.latitude, longitude: UserCurrentLocationCoordinates!.longitude, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Enabeling my location.
        mapView.isMyLocationEnabled = true

        // Enabeling location button. This adds mylocation Button to the buttom right corner of the map
        mapView.settings.myLocationButton = true
        
        // Enabeling compass button.
        mapView.settings.compassButton = true


        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: UserCurrentLocationCoordinates!.latitude, longitude: UserCurrentLocationCoordinates!.longitude)
        marker.title = "Current Location"
        marker.snippet = ""
        marker.map = mapView
    }
    

}
