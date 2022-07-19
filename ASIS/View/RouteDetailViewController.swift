
//
//  RouteDetailViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import MapKit
import CoreLocation
import DropDown
import CoreData

final class RouteDetailViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Properties
    
    private var data = [NSManagedObject]()
    var selectedService: Service!
    let locationManager = CLLocationManager()
    
    private var directionButton:UIButton!
    private var focusMeButton:UIButton!
    private var focusRouteButton:UIButton!
    
    var menu:DropDown!
    var routeOverlay:MKOverlay?
    var personCoordinate:CLLocationCoordinate2D?
    
    var selectedRoute: Route!{
        didSet{
            title = "\("Direction".localized): \(selectedRoute.destination ?? "Unknown")"
            
            let annotations = mapView.annotations.filter {
                $0.title != "person"
            }
            mapView.removeAnnotations(annotations)
            
            DispatchQueue.main.async {
                for point in self.selectedRoute.points! {
                    if point.stop_id != nil {
                        let pin = MKPointAnnotation()
                        pin.coordinate = CLLocationCoordinate2D(latitude: point.latitude!, longitude: point.longitude!)
                        self.mapView.addAnnotation(pin)
                    }
                }
            }
            
            
        }
    }
    
    let mapView : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    
    // MARK: Functions
    
    private func fetch(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        data = try! managedObjectContext!.fetch(fetchRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setMapConstraints()
        configureDropdown()
        configureButtons()
        selectedRoute = selectedService?.routes?[0]
        drawRoute()
        fetch()
        for datum in data {
            if selectedService.name == datum.value(forKey: "favoriteName") as? String{
                    return
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add-to-favorites"), style: .plain, target: self, action: #selector(addToFavorites))
    }
    
    @objc func addToFavorites(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedObjectContext!)
        let favorite = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        favorite.setValue(selectedService.name, forKey: "favoriteName")
        favorite.setValue(selectedService.description, forKey: "favoriteDescription")
        try? managedObjectContext?.save()
        navigationItem.rightBarButtonItem = nil
    }
    
    private func configureDropdown(){
        menu = DropDown()
        var destinations:[String] = []
        for route in selectedService!.routes!{
            destinations.append("\("direction".localized): \(route.destination ??  "Unknown")")
        }
        menu.dataSource = destinations
        menu.selectionAction = { index, title in
            self.selectedRoute = self.selectedService?.routes?[index]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // TODO: - update it, it just runs once
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        personCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let pin = MKPointAnnotation()
        guard let personCoordinate = personCoordinate else { return }
        pin.coordinate = personCoordinate
        pin.title = "person"
        mapView.addAnnotation(pin)
    }
    
    func drawRoute(){
        var coordinates: [CLLocationCoordinate2D] = []
        
        for point in selectedRoute.points!{
            coordinates.append(CLLocationCoordinate2D(latitude: point.latitude!, longitude: point.longitude!))
        }
        
        DispatchQueue.main.async {
            self.routeOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(self.routeOverlay!, level: .aboveRoads)
            let customEdgePadding:UIEdgeInsets = UIEdgeInsets (top: 50, left: 50, bottom: 50, right: 50)
            self.mapView.setVisibleMapRect(self.routeOverlay!.boundingMapRect, edgePadding: customEdgePadding,animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineCap = .round
        renderer.lineWidth = 6.0
        return renderer
    }
    
    func setMapConstraints() {
        view.addSubview(mapView)
        view.backgroundColor = .white
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }

}

// MARK: Utility Buttons
extension RouteDetailViewController{
    
    private func configureButtons(){
        directionButton = UIButton()
        directionButton.setImage(UIImage(named: "change-route"), for: .normal)
        directionButton.backgroundColor = .systemGreen
        directionButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        directionButton.layer.cornerRadius = 8
        directionButton.layer.opacity = 0.7
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        directionButton.addTarget(self, action: #selector(didTapChangeDirection), for: .touchUpInside)
        view.addSubview(directionButton)
        
        focusMeButton = UIButton()
        focusMeButton.setImage(UIImage(named: "person-location"), for: .normal)
        focusMeButton.backgroundColor = .systemBlue
        focusMeButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        focusMeButton.layer.cornerRadius = 8
        focusMeButton.layer.opacity = 0.7
        focusMeButton.translatesAutoresizingMaskIntoConstraints = false
        focusMeButton.addTarget(self, action: #selector(didTapFocusMe), for: .touchUpInside)
        view.addSubview(focusMeButton)
        
        focusRouteButton = UIButton()
        focusRouteButton.setImage(UIImage(named: "route"), for: .normal)
        focusRouteButton.backgroundColor = .systemOrange
        focusRouteButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        focusRouteButton.layer.cornerRadius = 8
        focusRouteButton.layer.opacity = 0.7
        focusRouteButton.translatesAutoresizingMaskIntoConstraints = false
        focusRouteButton.addTarget(self, action: #selector(didTapFocusRoute), for: .touchUpInside)
        view.addSubview(focusRouteButton)
        
        NSLayoutConstraint.activate([
            directionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            directionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            focusMeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            focusMeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            focusRouteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            focusRouteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
    }
    
    @objc func didTapFocusRoute(){
        DispatchQueue.main.async {
            let customEdgePadding:UIEdgeInsets = UIEdgeInsets (top: 50, left: 50, bottom: 50, right: 50)
            self.mapView.setVisibleMapRect(self.routeOverlay!.boundingMapRect, edgePadding: customEdgePadding,animated: true)
        }
    }
    
    @objc func didTapFocusMe(){
        guard let personCoordinate = personCoordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: personCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func didTapChangeDirection(){
        menu.show()
    }
}

extension RouteDetailViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil{
            //create view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        }else{
            //assign annotation
            annotationView?.annotation = annotation
        }
        
        if annotationView?.annotation?.title == "person" {
            annotationView?.image = UIImage(named: "person-annotation")
            annotationView?.displayPriority = .required
            return annotationView
        }
        
        annotationView?.image = UIImage(named: "bus-station-annotation")
        annotationView?.displayPriority = .defaultHigh
        
        return annotationView
    }
}
