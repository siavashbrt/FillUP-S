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
import MessageUI


class MainViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, MFMessageComposeViewControllerDelegate {
    
    var phoneNumber:String = "5038636736"

    func sendText(_ sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "درخواست فیلاپ برای آدرس زیر:" + "\n " + mapMarker.title!
            //controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
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
    
    let fillUpLabel:UILabel = {
        let label = UILabel()
            label.text = "Fill Up"
            label.textColor = .black
        return label
    }()
    
    let navBar:UINavigationBar = {
        let navBar = UINavigationBar()
            navBar.backgroundColor = .darkGray
        let navItem = UINavigationItem(title: "");
        let settingBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(onSettings(_:)))
            navItem.rightBarButtonItem = settingBtn
            navBar.setItems([navItem], animated: false)
        return navBar
    }()
    
    
    let buttomView:UIView = {
        let view = UIView()
        view.backgroundColor = darkBlue
        return view
    }()
    
    let fillupRequest:UIButton = {
        let button = UIButton()
            button.setTitle("Request Fill Up", for: .normal)
            button.setTitleColor(white, for: .normal)
            button.backgroundColor = gold
            button.addTarget(self, action: #selector(sendText(_:)), for: .touchUpInside)
        return button
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
        
        view.addSubview(buttomView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", view: buttomView)
        view.addConstraintsWithFormat(format: "V:[v0(100)]|", view: buttomView)
        
        buttomView.addSubview(fillupRequest)
        
        buttomView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", view: fillupRequest)
        buttomView.addConstraintsWithFormat(format: "V:[v0(50)]", view: fillupRequest)
        
        fillupRequest.centerYAnchor.constraint(equalTo: buttomView.centerYAnchor).isActive = true
        
        view.addSubview(mapView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", view: mapView)
        view.addConstraintsWithFormat(format: "V:|[v0]", view: mapView)
        
        mapView.bottomAnchor.constraint(equalTo: buttomView.topAnchor).isActive = true
    
        searchController?.searchBar.sizeToFit()

        view.addSubview(navBar)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", view: navBar)
        view.addConstraintsWithFormat(format: "V:|[v0]", view: navBar)
        
        navBar.addSubview(fillUpLabel)
        
        navBar.addConstraintsWithFormat(format: "H:|-10-[v0]", view: fillUpLabel)
        navBar.addConstraintsWithFormat(format: "V:[v0]", view: fillUpLabel)
        
        fillUpLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor).isActive = true

        view.addSubview(subView)
        subView.addSubview(searchBar)
        
        subView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        subView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        subView.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 40).isActive = true
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

