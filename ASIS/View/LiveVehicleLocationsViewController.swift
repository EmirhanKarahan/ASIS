//
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol LiveVehicleLocationsOutPut {
    func saveDatas(values: [Vehicle])
}

final class LiveVehicleLocationsViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    var timer = Timer()
    private var vehicles: [Vehicle] = [] {
        didSet{
            updateVehicleLocations()
        }
    }
    
    lazy var viewModel:LiveVehicleLocationsViewModel = LiveVehicleLocationsViewModel()
    
    private let mapView : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setMapConstraints()
        viewModel.setDelegate(output: self)
        viewModel.fetchVehicles()
        self.timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { _ in
            self.viewModel.fetchVehicles()
        })
    }
    
    func updateVehicleLocations(){
        let annotations = mapView.annotations.filter {
            $0.title != "person"
        }
        mapView.removeAnnotations(annotations)
        
        for vehicle in vehicles {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude!, longitude: vehicle.longitude!)
            mapView.addAnnotation(pin)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    
    // MARK: - update, just runs once
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            render(location)
        }
    }
    
    
    func render(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.title = "person"
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    func setMapConstraints(){
        view.addSubview(mapView)
        view.backgroundColor = .white
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
}

extension LiveVehicleLocationsViewController: LiveVehicleLocationsOutPut{
    func saveDatas(values: [Vehicle]) {
        vehicles = values
    }
}

extension LiveVehicleLocationsViewController: MKMapViewDelegate{
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
        
        annotationView?.image = UIImage(named: "bus-annotation")
        annotationView?.displayPriority = .defaultHigh
        
        if annotationView?.annotation?.title == "person" {
            annotationView?.image = UIImage(named: "person-annotation")
            annotationView?.displayPriority = .required
        }
        
        return annotationView
    }
}
