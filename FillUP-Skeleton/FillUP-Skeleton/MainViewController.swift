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
import GooglePlaces

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    lazy var settingsBtn:UIButton = {
        let btn = UIButton()
            let BtnImage = UIImage(named: "settings")
                btn.setImage(BtnImage, for: .normal)
                btn.addTarget(self, action: #selector(onSettings(_:)), for: .touchUpInside)
       return btn
    }()
    

    //  to get and manage user current location
    let locationManager = CLLocationManager()
    
    var mapView = GMSMapView()
    
    // searchbar variables
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // load the map and current location
        loadMapView()

        setupView()
    }

    func loadMapView() {
        
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
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
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

        guard let latitude = UserCurrentLocationCoordinates?.latitude,
                  let longtitude = UserCurrentLocationCoordinates?.longitude else {return}
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        marker.title = "Current Location"
        marker.snippet = ""
        marker.map = mapView
    }
    
    internal func setupView() {
        
        guard let searchBar = searchController?.searchBar else {return}
        
        view.addSubview(mapView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", view: mapView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", view: mapView)
    
        view.addSubview(settingsBtn)
        
        view.addConstraintsWithFormat(format: "H:[v0]-10-|", view: settingsBtn)
        view.addConstraintsWithFormat(format: "V:|-20-[v0]", view: settingsBtn)
    
        view.addSubview(searchBar)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", view: searchBar)
        view.addConstraintsWithFormat(format: "V:|-60-[v0(45)]|", view: searchBar)
        
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    internal func onSettings(_ sender: UIButton) {
        
        let settingsViewsController = SettingsTableViewController()
        self.navigationController?.pushViewController(settingsViewsController, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// Handle the user's selection.
extension MainViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
