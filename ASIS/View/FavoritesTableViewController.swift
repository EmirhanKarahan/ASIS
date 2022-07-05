//
//  FavoritesTableViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 4.07.2022.
//

import UIKit
import CoreData

final class FavoritesTableViewController: UITableViewController {
    
    var data = [NSManagedObject]()
    
    var services = [Service]()
    
    private let viewModel: BusServicesViewModel = BusServicesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        fetch()
        viewModel.setDelegate(output: self)
        viewModel.fetchServices()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for:indexPath)
        let favorite = data[indexPath.row]
        cell.textLabel?.text = favorite.value(forKey: "favoriteDescription") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete".localized) { _,_,_ in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            managedObjectContext?.delete(self.data[indexPath.row])
            try? managedObjectContext?.save()
            self.fetch()
        }
        deleteAction.backgroundColor = .systemRed
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = data[indexPath.row]
        let name = favorite.value(forKey: "favoriteName") as! String
        guard let selectedService = findServiceByName(serviceName: name) else { return }
        let vc = RouteDetailViewController()
        vc.selectedService = selectedService
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        data = try! managedObjectContext!.fetch(fetchRequest)
        tableView.reloadData()
    }
    
    func findServiceByName(serviceName name:String) -> Service? {
        if let i = services.firstIndex(where: { $0.name == name }) {
            return services[i]
        }
        return nil
    }

}

extension FavoritesTableViewController: BusServicesOutput{
    func saveDatas(values: [Service]) {
        services = values
    }
}
