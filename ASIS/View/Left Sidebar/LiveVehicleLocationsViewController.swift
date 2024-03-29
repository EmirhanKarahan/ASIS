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
    private var timer = Timer()
    private var busAnnotations = [BusAnnotation]()
    private var personAnnotation:MKPointAnnotation!
    private var isSetCoordinatesMoreThanOnce:Bool = false
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
        mapView.isRotateEnabled = false
        setMapConstraints()
        viewModel.setDelegate(output: self)
        viewModel.fetchVehicles()
        title = "Bus Locations".localized
        self.timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { _ in
            self.viewModel.fetchVehicles()
        })
    }
    
    func updateVehicleLocations(){
        for annotation in busAnnotations {
            UIView.animate(withDuration: 0.5) { [self] in
                if let vehicle = self.vehicles.first(where: { $0.vehicleID == annotation.vehicleID }) {
                    annotation.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
                    annotation.angle = vehicle.heading ?? 0
                }
            }
        }
        
        if isSetCoordinatesMoreThanOnce { return }
        
        for vehicle in vehicles {
            let pin = BusAnnotation(coordinate: CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude), vehicleID: vehicle.vehicleID, angle: vehicle.heading ?? 0)
            pin.title = "\(vehicle.destination ?? "unknown")"
            busAnnotations.append(pin)
        }
        
        mapView.addAnnotations(busAnnotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
        isSetCoordinatesMoreThanOnce = true
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
        personAnnotation = MKPointAnnotation()
        personAnnotation.title = "You".localized
        personAnnotation.coordinate = coordinate
        mapView.addAnnotation(personAnnotation)
    }
    
    func setMapConstraints(){
        view.addSubview(mapView)
        view.backgroundColor = .white
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
}

extension LiveVehicleLocationsViewController: LiveVehicleLocationsOutPut{
    func saveDatas(values: [Vehicle]) {
        vehicles = values
    }
}

extension LiveVehicleLocationsViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "busAnnotation")
        
        if annotationView == nil {
            //create view
            annotationView = BusAnnotationView(annotation: annotation, reuseIdentifier: "busAnnotation")
        } else {
            //assign annotation
            annotationView?.annotation = annotation
        }
        
        if annotationView?.annotation?.title == "You".localized {
            annotationView?.image = UIImage(named: "person-annotation")
            annotationView?.displayPriority = .required
            return annotationView
        }
        
        annotationView?.image = UIImage(named: "arrow")
        
        if let anno = annotation as? BusAnnotation {
            annotationView?.image = UIImage(named: "arrow")?.rotate(angle: anno.angle)
        }
        
        let breathAnimation = CABasicAnimation(keyPath: "opacity")
        breathAnimation.fromValue = 0.7
        breathAnimation.toValue = 1
    
        let animations = CAAnimationGroup()
        animations.duration = 0.8
        animations.repeatCount = .infinity
        animations.animations = [breathAnimation]
        
        annotationView?.layer.add(animations, forKey: nil)
        annotationView?.displayPriority = .defaultHigh
        
        return annotationView
    }
    
}
