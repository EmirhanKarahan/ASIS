//
//  HowToGoViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 22.07.2022.
//

import UIKit
import FloatingPanel
import MapKit

protocol HowToGoOutput {
    func saveStops(values: [Stop])
}

final class HowToGoViewController: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate {
    private var fpc: FloatingPanelController!
    lazy private var viewModel:HowToGoViewModel = HowToGoViewModel()
    
    private var startingPoint:HowToGoPoint!
    private var targetPoint:HowToGoPoint!
    private var currentPersonLocation:CLLocation!
    
    private var startingStop:Stop!
    private var targetStop:Stop!
    private var nearestLocation:CLLocationCoordinate2D!
    
    func startHowToGo(startingPoint:HowToGoPoint, targetPoint:HowToGoPoint){
        self.startingPoint = startingPoint
        self.targetPoint = targetPoint

        nearestLocation = (currentPersonLocation.nearestCoordinate(locations: stops.map({return CLLocationCoordinate2D(latitude: $0.latitude!, longitude: $0.longitude!)})) )
        startingStop = stops.first(where: { $0.longitude == nearestLocation.longitude && $0.latitude == nearestLocation.latitude })
        print(startingPoint.pointName)
        print(startingStop.name)
        
    }
    
    private var stops:[Stop] = [] {
        didSet{
            let vc = FloatingPanelContentTableViewController()
            vc.parentVC = self
            vc.stops = stops
            configureFloatingPanelWithVC(VC: vc)
        }
    }
    
    private let locationManager = CLLocationManager()
    private let mapView : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        viewModel.setDelegate(output: self)
        viewModel.fetchStops()
        configureMapView()
        tabBarController?.tabBar.layer.backgroundColor = UIColor.white.cgColor
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
            currentPersonLocation = location
        }
    }
    
    private func render(_ location: CLLocation) {
        let personCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let pin = MKPointAnnotation()
        pin.coordinate = personCoordinate
        pin.title = "person"
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
    }
    
    private func configureFloatingPanelWithVC(VC contentVC: UITableViewController){
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.track(scrollView: contentVC.tableView)
        fpc.addPanel(toParent: self)
    }
    
    private func configureMapView(){
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
}

extension HowToGoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "busAnnotation")
        
        if annotationView == nil{
            annotationView = BusAnnotationView(annotation: annotation, reuseIdentifier: "busAnnotation")
        }else{
            annotationView?.annotation = annotation
        }
        
        if annotationView?.annotation?.title == "person" {
            annotationView?.image = UIImage(named: "person-annotation")
            annotationView?.displayPriority = .required
            return annotationView
        }
        
        if let anno = annotation as? BusAnnotation {
            annotationView?.image = UIImage(named: "arrow")?.rotate(angle: anno.angle)
            annotationView?.displayPriority = .required
            let breathAnimation = CABasicAnimation(keyPath: "opacity")
            breathAnimation.fromValue = 0.7
            breathAnimation.toValue = 1
        
            let animations = CAAnimationGroup()
            animations.duration = 0.5
            animations.repeatCount = .infinity
            animations.animations = [breathAnimation]
            
            annotationView?.layer.add(animations, forKey: nil)
            return annotationView
        }
        
        annotationView?.image = UIImage(named: "bus-station-annotation-2")
        annotationView?.displayPriority = .required

        return annotationView
    }
}

extension HowToGoViewController:HowToGoOutput{
    func saveStops(values: [Stop]) {
        stops = values
    }
    
}
