//
//  FavoritesTableViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 4.07.2022.
//

import UIKit
import CoreData

extension FavoritesTableViewController {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    func restore() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
}

final class FavoritesTableViewController: UITableViewController {
    
    var data = [NSManagedObject](){
        didSet{
            if data.count <= 0 {
                setEmptyMessage("Your favorites are empty, visit routes and try adding a favorite.".localized)
            }else {
                restore()
            }
        }
    }
    var services = [Service]()
    
    private let viewModel: BusServicesViewModel = BusServicesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        fetch()
        viewModel.setDelegate(output: self)
        viewModel.fetchServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetch()
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
        let favorite = self.data[indexPath.row]
        let name = favorite.value(forKey: "favoriteName") as! String
        guard let selectedService = self.findServiceByName(serviceName: name) else { print("🟨 Couldn't find service"); return }
        let vc = RouteDetailsViewController()
        vc.selectedService = selectedService
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        data = try! managedObjectContext!.fetch(fetchRequest)
        tableView.reloadData()
    }
    
    func findServiceByName(serviceName name:String) -> Service? {
        if let service = services.first(where: { $0.name == name }) {
            return service
        }
        return nil
    }
    
}

extension FavoritesTableViewController: BusServicesOutput{
    func saveServices(values: [Service]) {
        services = values
    }
}
