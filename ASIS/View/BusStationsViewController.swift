//
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol BusStationsOutPut {
    func saveDatas(values: [Stop])
}

final class BusStationsViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    lazy var viewModel:BusStationsViewModel = BusStationsViewModel()
    
    private var stops: [Stop] = [] {
        didSet {
            let annotations = mapView.annotations.filter {
                $0.title != "You".localized
            }
            mapView.removeAnnotations(annotations)
            
            for stop in stops {
                let pin = MKPointAnnotation()
                pin.coordinate = CLLocationCoordinate2D(latitude: stop.latitude!, longitude: stop.longitude!)
                pin.title = "\(stop.name ?? "unknown")"
                mapView.addAnnotation(pin)
            }
            
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    let mapView : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapConstraints()
        mapView.delegate = self
        viewModel.setDelegate(output: self)
        viewModel.fetchStops()
        title = "Bus Stops".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let pin = MKPointAnnotation()
        pin.title = "You".localized
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

extension BusStationsViewController: BusStationsOutPut{
    func saveDatas(values: [Stop]) {
        stops = values
    }
}

extension BusStationsViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "stopAnnotation")
        
        if annotationView == nil{
            annotationView = StopAnnotationView(annotation: annotation, reuseIdentifier: "stopAnnotation")
        }else{
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "bus-station-annotation-1")
        annotationView?.displayPriority = .defaultHigh
        
        if annotationView?.annotation?.title == "You".localized {
            annotationView?.image = UIImage(named: "person-annotation")
            annotationView?.displayPriority = .required
        }
        
        return annotationView
    }
}
