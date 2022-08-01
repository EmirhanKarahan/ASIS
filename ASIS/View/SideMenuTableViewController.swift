//
//  SideMenuTableViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 29.06.2022.
//

import UIKit
import FirebaseAuth

final class SideMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemGray6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sideMenuCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath)
        cell.backgroundColor = .systemGray6
        
        switch indexPath.row{
        case 0:
            cell.textLabel?.text = "Bus Locations".localized
            cell.imageView?.image = UIImage(named: "bus-location")
        case 1:
            cell.textLabel?.text = "Bus Stops".localized
            cell.imageView?.image = UIImage(named: "station")
        case 2:
            cell.textLabel?.text = "Account Settings".localized
            cell.imageView?.image = UIImage(named: "account")
        case 3:
            cell.textLabel?.text = "Share the App".localized
            cell.imageView?.image = UIImage(named: "app-store")
        case 4:
            cell.textLabel?.text = "Change Language".localized
            cell.imageView?.image = UIImage(named: "language")
        case 5:
            cell.textLabel?.text = "Sign out".localized
            cell.imageView?.image = UIImage(named: "sign-out")
        default:
            print("Faulty index, on file SideMenuTableViewController")
        }
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row{
        case 0:
            navigationController?.pushViewController(LiveVehicleLocationsViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(BusStationsViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(AccountSettingsViewController(), animated: true)
        case 3:
            shareTapped()
        case 4:
            navigationController?.pushViewController(LanguagePreferencesViewController(), animated: true)
        case 5:
            do {
                try FirebaseAuth.Auth.auth().signOut()
                UIApplication.shared.windows.first?.rootViewController = LoginViewController()
                print("Signed out")
            } catch {
                print("Couldn't sign out, error occured")
            }
        default:
            print("Faulty index, on file SideMenuTableViewController")
        }
    }
    
    func shareTapped() {
        var lang:String
        if let locale = UserDefaults.standard.string(forKey: "i18n_language") {
            lang = locale
        } else {
            lang = "en"
        }
        guard let url = URL(string: "https://apps.apple.com/\(lang)/app/ak%C4%B1ll%C4%B1-biletim/id1182947965") else {return}
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
