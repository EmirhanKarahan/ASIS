

import UIKit
import CoreLocation

final class DestinationsFloatingTableViewController: UITableViewController, UISearchBarDelegate {
    
    private let searchBar = UISearchBar()
    
    var stops = [Stop]()
    var filteredStops = [Stop]()
    var pointsInHeaderView:PointsInHeaderView!
    
    var parentVC:HowToGoViewController!
    private var startingPoint:HowToGoPoint?
    private var targetPoint:HowToGoPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "custom")
        filteredStops = stops
        pointsInHeaderView = PointsInHeaderView()
        pointsInHeaderView.translatesAutoresizingMaskIntoConstraints = false
        pointsInHeaderView.parentVC = self
        searchBar.sizeToFit()
        searchBar.delegate = self
        view.addSubview(pointsInHeaderView)
        NSLayoutConstraint.activate([
            pointsInHeaderView.widthAnchor.constraint(equalToConstant: 160),
            pointsInHeaderView.heightAnchor.constraint(equalToConstant: 100),
            pointsInHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pointsInHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(pointsInHeaderView)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Starting Point".localized
        }
        return "Destination Point".localized
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let vw = UIView()
            vw.backgroundColor = tableView.backgroundColor
            let label = UILabel()
            label.text =  "Destination Point".localized
            label.textColor = .systemGray
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            vw.addSubview(label)
            vw.addSubview(searchBar)
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            vw.heightAnchor.constraint(equalToConstant: 100).isActive = true
            label.leadingAnchor.constraint(equalTo: vw.leadingAnchor, constant: 18).isActive = true
           
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: vw.topAnchor, constant: 5),
                searchBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
                searchBar.centerXAnchor.constraint(equalTo: vw.centerXAnchor),
                searchBar.widthAnchor.constraint(equalTo: vw.widthAnchor),
            ])
            return vw
        }
        return nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStops = []

        if searchText == "" {
            filteredStops = stops
            tableView.reloadData()
            return
        }

        for stop in stops {
            if "\(stop.direction ?? "unknown") - \(stop.name ?? "unknown")".lowercased().contains(searchText.lowercased()){
                filteredStops.append(stop)
            }
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : filteredStops.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath)
            cell.textLabel?.text = "Konumunuz"
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath)
        cell.textLabel?.text = "\(filteredStops[indexPath.row].direction ?? "unknown") - \(filteredStops[indexPath.row].name ?? "unknown")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            startingPoint = HowToGoPoint(pointName: "You".localized, coordinate: CLLocationCoordinate2D(), stop: nil)
            pointsInHeaderView.fromLabel.text = "You".localized
            return
        }
        
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude = filteredStops[indexPath.row].latitude!
        coordinate.longitude = filteredStops[indexPath.row].longitude!
        targetPoint = HowToGoPoint(pointName: filteredStops[indexPath.row].name ?? "?", coordinate: coordinate, stop: filteredStops[indexPath.row])
        pointsInHeaderView.toLabel.text = targetPoint?.pointName
    }
    
    func goButtonTapped(){
        if let start = startingPoint, let target = targetPoint {
            parentVC.startHowToGo(startingPoint: start, targetPoint: target)
        }
    }
    
}

final class PointsInHeaderView : UIView {
    
    var fromInfoLabel:UILabel!
    var fromLabel:UILabel!
    var toInfoLabel:UILabel!
    var toLabel:UILabel!
    var goButton:UIButton!
    var parentVC:DestinationsFloatingTableViewController!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 10
        
        fromInfoLabel = UILabel()
        fromInfoLabel.text = "From:".localized
        fromInfoLabel.font = .systemFont(ofSize: 12)
        fromInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(fromInfoLabel)
        
        fromLabel = UILabel()
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = .systemFont(ofSize: 12)
        self.addSubview(fromLabel)
        
        toInfoLabel = UILabel()
        toInfoLabel.text = "To:".localized
        toInfoLabel.font = .systemFont(ofSize: 12)
        toInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toInfoLabel)
        
        toLabel = UILabel()
        toLabel.font = .systemFont(ofSize: 12)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toLabel)
        
        goButton = UIButton()
        goButton.setTitle("Go".localized, for: .normal)
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        goButton.backgroundColor = .systemBlue
        goButton.layer.cornerRadius = 4
        goButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(goButton)
        
        NSLayoutConstraint.activate([
            fromInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            fromInfoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            
            fromLabel.leadingAnchor.constraint(equalTo: fromInfoLabel.trailingAnchor, constant: 2),
            fromLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            fromLabel.widthAnchor.constraint(equalToConstant: 110),
            
            toInfoLabel.leadingAnchor.constraint(equalTo: fromInfoLabel.leadingAnchor),
            toInfoLabel.topAnchor.constraint(equalTo: fromInfoLabel.bottomAnchor, constant: 10),
            
            toLabel.leadingAnchor.constraint(equalTo: toInfoLabel.trailingAnchor, constant: 2),
            toLabel.topAnchor.constraint(equalTo: fromInfoLabel.bottomAnchor, constant: 10),
            toLabel.widthAnchor.constraint(equalToConstant: 110),
            
            goButton.topAnchor.constraint(equalTo: toInfoLabel.bottomAnchor, constant:10),
            goButton.leadingAnchor.constraint(equalTo: toInfoLabel.leadingAnchor),
            goButton.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goButtonTapped(){
        parentVC.goButtonTapped()
    }
    
    
}
