//
//  RoutesTableViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 28.07.2022.
//

import UIKit

final class JourneysFloatingTableViewController: UITableViewController {
    
    var journeys:[Journey]!
    var formatter:DateIntervalFormatter!
    var parentVC:HowToGoViewController!
    
    var headerView:UIView!
    var exitButton:UIButton!
    
    private func configureHeaderView(){
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(headerView)
        
        exitButton = UIButton()
        exitButton.setImage(UIImage(named: "close"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        exitButton.setTitleColor(UIColor.systemRed, for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            exitButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -5),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        ])
    }
    
    @objc func exitButtonTapped(){
        parentVC.fpc2.move(to: .hidden, animated: true, completion: {self.parentVC.fpc2.removePanelFromParent(animated: true)})
        parentVC.fpc.move(to: .half, animated: true)
        parentVC.clearStopAnnotations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerView
        configureHeaderView()
        tableView.register(JourneyTableViewCell.self, forCellReuseIdentifier: JourneyTableViewCell.identifier)
        formatter = DateIntervalFormatter()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journeys.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Choose a journey".localized
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JourneyTableViewCell.identifier, for: indexPath) as! JourneyTableViewCell
        cell.serviceNameLabel.text = "\(journeys[indexPath.row].serviceName)"
        cell.directionNameLabel.text = "\(journeys[indexPath.row].destination)"
        cell.durationLabel.text = "\(calculateArrivalTime(journey: journeys[indexPath.row]))\("min".localized)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentVC.selectedJourney = journeys[indexPath.row]
    }
    
    private func calculateArrivalTime(journey:Journey) -> Int {
        let departureTime = journey.departures.first!.time
        let arrivalTime = journey.departures.last!.time
        
        let departureTimeHourSection = Int(departureTime.prefix(2))!
        let departureTimeMinuteSection = Int(departureTime.suffix(2))!
        let arrivalTimeHourSection = Int(arrivalTime.prefix(2))!
        let arrivalTimeMinuteSection = Int(arrivalTime.suffix(2))!
        
        let today = Date().convert(from: TimeZone(abbreviation: "GMT+1")!, to: TimeZone(abbreviation: "GMT+3")!)
        let hours   = (Calendar.current.component(.hour, from: today))
        let minutes = (Calendar.current.component(.minute, from: today))
        
        let hourDifference =  arrivalTimeHourSection -  departureTimeHourSection + departureTimeHourSection - hours
        let minuteDifference =  arrivalTimeMinuteSection - departureTimeMinuteSection + departureTimeMinuteSection - minutes
        
        return hourDifference * 60 + minuteDifference
    }
   
}

extension Date {

    func convert(from timeZone: TimeZone, to destinationTimeZone: TimeZone) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: timeZone, from: self)
        components.timeZone = destinationTimeZone
        return calendar.date(from: components)!
    }
}
