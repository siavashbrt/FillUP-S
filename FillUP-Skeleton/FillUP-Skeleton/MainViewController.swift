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
    
    // Zoom Levels
    // 1: World
    // 5: Landmass/continent
    // 10: City
    // 15: Streets
    // 20: Buildings
    let streetZoom: Float = 15.0
    
    let geocoder = GMSGeocoder()
    
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
        let camera = GMSCameraPosition.camera(withLatitude: 35.715298, longitude: 51.404343, zoom: streetZoom)
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
        searchController?.searchBar.text = marker.title
        return true
    }
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        //mapView.clear()
        updateMarkerLocationoordinates()
    }
    
    
    func setMapMarkertoSelectedPlace(selectedPlace: GMSPlace)
    {
        // Creates a marker in the center of the map.
        mapMarker.position = CLLocationCoordinate2D(latitude: selectedPlace.coordinate.latitude, longitude: selectedPlace.coordinate.longitude)
        mapMarker.title = selectedPlace.name
        mapMarker.snippet = selectedPlace.formattedAddress
        mapMarker.map = mapView
    }
    
    // mapView:idleAtCameraPosition: is invoked once the camera position on GMSMapView becomes idle,
    // and specifies the relevant camera position. At this point, all animations and gestures have stopped.
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                self.mapMarker.position = cameraPosition.target
                self.mapMarker.title = result.lines?[0]
                self.mapMarker.snippet = result.lines?[1]
                self.mapMarker.map = mapView
            }
        }
    }
    
    func updateMarkerLocationoordinates()
    {
        mapMarker.position = CLLocationCoordinate2D(latitude: mapView.camera.target.latitude,
        longitude: mapView.camera.target.longitude)
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
        
        // Remove prevoise marker
        //mapView.clear()

        
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
    
    func setMapLocation(selectedPlace: GMSPlace)
    {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: selectedPlace.coordinate.latitude, longitude: selectedPlace.coordinate.longitude))
        mapView.animate(toZoom: streetZoom)
    }
}


// Camera and View  https://developers.google.com/maps/documentation/ios-sdk/views
// Map Events https://developers.google.com/maps/documentation/ios-sdk/events

