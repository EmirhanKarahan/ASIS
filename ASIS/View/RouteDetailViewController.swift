
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

class RouteDetailViewController: UIViewController, CLLocationManagerDelegate {
    
    var selectedService: Service!
    let locationManager = CLLocationManager()
    var selectedRoute: Route!{
        didSet{
            title = "Direction: \(selectedRoute.destination ?? "Unknown") ⬇"
            
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
    
    var menu:DropDown!
    
    let mapView : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    var routeOverlay:MKOverlay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setMapConstraints()
        configureDropdown()
        selectedRoute = selectedService?.routes?[0]
        drawRoute()
    }
    
    func configureDropdown(){
        menu = DropDown()
        var destinations:[String] = []
        for route in selectedService!.routes!{
            destinations.append("direction: " + route.destination!)
        }
        menu.dataSource = destinations
        menu.selectionAction = { index, title in
            self.selectedRoute = self.selectedService?.routes?[index]
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        navigationController?.navigationBar.addGestureRecognizer(gesture)
    }
    
    @objc func didTapTopItem(){
        menu.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - update it, just runs once
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
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
        renderer.strokeColor = .green
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
        
        annotationView?.image = UIImage(named: "bus-station-annotation")
        annotationView?.displayPriority = .defaultHigh
        
        if annotationView?.annotation?.title == "person" {
            annotationView?.image = UIImage(named: "person-annotation")
            annotationView?.displayPriority = .required
        }
        
        return annotationView
    }
}
