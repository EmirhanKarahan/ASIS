

import UIKit

final class JourneyDetailFloatingTableViewController: UITableViewController {
    
    var headerView:UIView!
    var exitButton:UIButton!
    
    var journey:Journey!
    var parentVC:HowToGoViewController!
    
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
        parentVC.fpc3.move(to: .hidden, animated: true, completion: {self.parentVC.fpc3.removePanelFromParent(animated: true)})
        parentVC.fpc2.move(to: .half, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerView
        configureHeaderView()
        tableView.register(DepartureTableViewCell.self, forCellReuseIdentifier: DepartureTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journey.departures.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(journey.serviceName) - \(journey.destination) \("details".localized)".localized
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DepartureTableViewCell.identifier, for: indexPath) as! DepartureTableViewCell
        cell.stopNameLabel.text = journey.departures[indexPath.row].name
        cell.timeLabel.text = journey.departures[indexPath.row].time
        return cell
    }
    
}
