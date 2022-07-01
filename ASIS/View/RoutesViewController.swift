//
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol BusServicesOutput{
    func saveDatas(values: [Service])
}

final class RoutesViewController: UITableViewController, UISearchBarDelegate {
    
    let searchBar = UISearchBar()
    
    var services: [Service] = [] {
        didSet{
            filteredServices = services
            tableView.reloadData()
        }
    }
    var filteredServices: [Service] = []
    let viewModel: BusServicesViewModel = BusServicesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setDelegate(output: self)
        viewModel.fetchServices()
        filteredServices = services
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "routeCell")
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
            let ac = UIAlertController(title: "Error", message: "Weird, but no routes found.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true)
            return
        }
        
        let vc = RouteDetailViewController()
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
    func saveDatas(values: [Service]) {
        services = values
    }
}
