//
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol BusServicesOutput{
    func saveServices(values: [Service])
}

final class RoutesViewController: UITableViewController, UISearchBarDelegate {
    
    private let searchBar = UISearchBar()
    private var spinner:UIActivityIndicatorView!
    
    private var services: [Service] = [] {
        didSet{
            
            filteredServices = services
            spinner.stopAnimating()
            tableView.reloadData()
        }
    }
    
    private var vehicles = [Vehicle]()
    
    private var filteredServices: [Service] = []
    private let viewModel: BusServicesViewModel = BusServicesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setDelegate(output: self)
        viewModel.fetchServices()
        filteredServices = services
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "routeCell")
        configureViews()
    }
    
    private func configureViews() {
        spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredServices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath)
        cell.textLabel?.text = filteredServices[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedService = filteredServices[indexPath.row]
        if selectedService.routes!.isEmpty {
            let ac = UIAlertController(title: "Error", message: "Weird, but no routes found.".localized, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok".localized, style: .cancel))
            present(ac, animated: true)
            return
        }
        
        let vc = RouteDetailsViewController()
        vc.selectedService = selectedService
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredServices = []
        
        if searchText == "" {
            filteredServices = services
            tableView.reloadData()
            return
        }
        
        for service in services {
            if service.description!.lowercased().contains(searchText.lowercased()){
                filteredServices.append(service)
            }
        }
        tableView.reloadData()
    }
    
    
}

extension RoutesViewController: BusServicesOutput{
    func saveServices(values: [Service]) {
        services = values
    }
}
