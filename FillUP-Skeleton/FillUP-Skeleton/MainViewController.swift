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

<<<<<<< Updated upstream
class MainViewController: UIViewController, CLLocationManagerDelegate {
=======
class MainViewController: UIViewController {
    
    lazy var settingsBtn:UIButton = {
        let btn = UIButton()
            let BtnImage = UIImage(named: "settings")
            btn.setImage(BtnImage, for: .normal)
            btn.addTarget(self, action: #selector(onSettings(_:)), for: .touchUpInside)
       return btn
    }()
>>>>>>> Stashed changes

    //  to get and manage user current location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
            view.backgroundColor = .white
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
<<<<<<< Updated upstream
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
        // coordinate 35.715298,51.404343 (Tehran) at zoom level 8.0.
        let camera = GMSCameraPosition.camera(withLatitude: 35.715298, longitude: 51.404343, zoom: 8.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Enabeling my location.
        mapView.isMyLocationEnabled = true

        // Enabeling location button. This adds mylocation Button to the buttom right corner of the map
        mapView.settings.myLocationButton = true
        
        // Enabeling compass button.
        mapView.settings.compassButton = true

        //mapView.animate(toViewingAngle: 45)

        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: (UserCurrentLocationCoordinates?.latitude)!, longitude: (UserCurrentLocationCoordinates?.longitude)!))

        // To set the zoom level when mylocation button is pressed
        mapView.animate(toZoom: 6)

        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: UserCurrentLocationCoordinates!.latitude, longitude: UserCurrentLocationCoordinates!.longitude)
        marker.title = "Current Location"
        marker.snippet = ""
        marker.map = mapView
    }
    

=======
    internal func setupView() {
        
        view.addSubview(settingsBtn)
        
        view.addConstraintsWithFormat(format: "H:[v0]-10-|", view: settingsBtn)
        view.addConstraintsWithFormat(format: "V:|-40-[v0]", view: settingsBtn)
    }
    
    internal func onSettings(_ sender: UIButton) {
    
        let settingsViewsController = SettingsTableViewController()
        self.navigationController?.pushViewController(settingsViewsController, animated: true)
    }
>>>>>>> Stashed changes
}
