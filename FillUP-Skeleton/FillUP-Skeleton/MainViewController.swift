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

class MainViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    lazy var settingsBtn:UIButton = {
        let btn = UIButton()
            let BtnImage = UIImage(named: "settings")
                btn.setImage(BtnImage, for: .normal)
                btn.addTarget(self, action: #selector(onSettings(_:)), for: .touchUpInside)
       return btn
    }()
    
    lazy var mapMarker:GMSMarker = {
        let mrk = GMSMarker()
        mrk.icon = UIImage(named: "marker")
        return mrk
    }()
    
    let subView:UIView = {
        let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Needs More Work
        guard let userKey = UserDefaults.standard.value(forKey: KEY_UID) as? String else {return}
        
        if userKey.isEmpty {
            self.dismiss(animated: true, completion: nil)
        }
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
        
        mapView.delegate = self
        
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
        mapMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        mapMarker.title = "Current Location"
        mapMarker.snippet = ""
        mapMarker.map = mapView
    }
    
    internal func setupView() {
        
        guard let searchBar = searchController?.searchBar else {return}
        
        view.addSubview(mapView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", view: mapView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", view: mapView)

        searchController?.searchBar.sizeToFit()

    
        view.addSubview(settingsBtn)
        
        view.addConstraintsWithFormat(format: "H:[v0]-10-|", view: settingsBtn)
        view.addConstraintsWithFormat(format: "V:|-20-[v0]", view: settingsBtn)
    
        view.addSubview(subView)
        subView.addSubview(searchBar)
        
        subView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        subView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        subView.topAnchor.constraint(equalTo: settingsBtn.topAnchor, constant: 40).isActive = true
        subView.heightAnchor.constraint(equalToConstant: searchBar.frame.height).isActive = true
        
    }
    
    internal func onSettings(_ sender: UIButton) {
        
        let settingsViewsController = SettingsTableViewController()
        let navController = UINavigationController(rootViewController: settingsViewsController)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        searchController?.searchBar.text = marker.snippet
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
        
        // Set the map location
        setMapLocation(selectedPlace: place)
        
        // Set the marker
        setMapMarkertoSelectedPlace(selectedPlace: place)

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
    
    func setMapMarkertoSelectedPlace(selectedPlace: GMSPlace)
    {
    // Creates a marker in the center of the map.
    mapMarker.position = CLLocationCoordinate2D(latitude: selectedPlace.coordinate.latitude, longitude: selectedPlace.coordinate.longitude)
    mapMarker.title = selectedPlace.name
    mapMarker.snippet = selectedPlace.formattedAddress
    mapMarker.map = mapView
    }
    
    func setMapLocation(selectedPlace: GMSPlace)
    {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: selectedPlace.coordinate.latitude, longitude: selectedPlace.coordinate.longitude))
        mapView.animate(toZoom: 15)
    }
}
