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
    func saveJourneys(values: [Journey])
}

final class HowToGoViewController: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate {
    
     var fpc: FloatingPanelController!
     var fpc2: FloatingPanelController!
     var fpc3: FloatingPanelController!
    
    lazy private var viewModel:HowToGoViewModel = HowToGoViewModel()
    
    private var startingPoint:HowToGoPoint!
    private var targetPoint:HowToGoPoint!
    private var currentPersonLocation:CLLocation!
    var stopAnnotations:[MKPointAnnotation] = []
    var selectedJourney:Journey? {
        didSet{
            if let floating  = fpc3 {
                floating.removePanelFromParent(animated: true)
            }
            clearStopAnnotations()
            setStopLocations()
            let vc = JourneyDetailFloatingTableViewController()
            vc.journey = selectedJourney
            vc.parentVC = self
            fpc2.move(to: .hidden, animated: true)
            fpc3 = FloatingPanelController()
            fpc3.delegate = self
            fpc3.set(contentViewController: vc)
            fpc3.track(scrollView: vc.tableView)
            fpc3.addPanel(toParent: self)
            fpc3.move(to: .hidden, animated: false)
            fpc3.move(to: .half, animated: true)
        }
    }
    
    func clearStopAnnotations(){
        mapView.removeAnnotations(stopAnnotations)
        stopAnnotations.removeAll()
    }
    
    private var startingStop:Stop!
    private var targetStop:Stop!
    private var nearestLocation:CLLocationCoordinate2D!
    
    private var journeys:[Journey] = [] {
        didSet{
            if journeys.count > 0 {
                let vc = JourneysFloatingTableViewController()
                vc.journeys = journeys
                vc.parentVC = self
                fpc.move(to: .hidden, animated: true)
                fpc2 = FloatingPanelController()
                fpc2.delegate = self
                fpc2.set(contentViewController: vc)
                fpc2.track(scrollView: vc.tableView)
                fpc2.addPanel(toParent: self)
                fpc2.move(to: .hidden, animated: false)
                fpc2.move(to: .half, animated: true)
            } else {
                let vc = UIAlertController(title: "Ups", message: "Couldn't find any routes", preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(vc, animated: true)
            }
        }
    }
    
    private var stops:[Stop] = [] {
        didSet{
            let vc = DestinationsFloatingTableViewController()
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
    
    func setStopLocations() {
        for stop in stops {
            for departure in selectedJourney!.departures {
                if stop.stopID == departure.stopID {
                    let pin = MKPointAnnotation()
                    pin.coordinate = CLLocationCoordinate2D(latitude: stop.latitude!, longitude: stop.longitude!)
                    pin.title = "\(stop.name ?? "unknown")"
                    stopAnnotations.append(pin)
                }
            }
        }
      
        mapView.addAnnotations(stopAnnotations)
    }
    
    func startHowToGo(startingPoint:HowToGoPoint, targetPoint:HowToGoPoint){
        self.startingPoint = startingPoint
        self.targetPoint = targetPoint

        nearestLocation = (currentPersonLocation.nearestCoordinate(locations: stops.map({return CLLocationCoordinate2D(latitude: $0.latitude!, longitude: $0.longitude!)})) )
        startingStop = stops.first(where: { $0.longitude == nearestLocation.longitude && $0.latitude == nearestLocation.latitude })
        viewModel.fetchStopToStopTimetableJourneys(startStopID: startingStop.stopID!, finalStopID: (targetPoint.stop?.stopID)!)
    }
    
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
        pin.title = "You".localized
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
    }
    
    private func configureFloatingPanelWithVC(VC contentVC: UITableViewController){
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.track(scrollView: contentVC.tableView)
        fpc.addPanel(toParent: self)
        fpc.move(to: .hidden, animated: false)
        fpc.move(to: .half, animated: true)
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
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        }else{
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "bus-station-annotation-1")
        annotationView?.displayPriority = .required
        
        if annotationView?.annotation?.title == "You".localized {
            annotationView?.image = UIImage(named: "person-annotation")
        }
        
        return annotationView
    }
}

extension HowToGoViewController:HowToGoOutput{
    
    func saveJourneys(values: [Journey]) {
        journeys = values
    }
    
    func saveStops(values: [Stop]) {
        stops = values
    }
    
}
