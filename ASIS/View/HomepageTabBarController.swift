//
//  CustomTabBarController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit
import SideMenu
import Alamofire

final class HomepageTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllersToTabBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "burger-menu"), style: .plain, target: self, action: #selector(openSideMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorites"), style: .plain, target: self, action: #selector(openFavorites))
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    @objc func openSideMenu(){
        let menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
        menu.leftSide = true
        present(menu, animated: true, completion: nil)
    }
    
    @objc func openFavorites(){
        let favorites = SideMenuNavigationController(rootViewController: FavoritesTableViewController())
        present(favorites, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !(NetworkReachabilityManager()?.isReachable ?? false){
            let ac = UIAlertController(title: "Network connection missing", message: "Please, connect to a network", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok".localized, style: .default))
            present(ac, animated: true)
        }
    }

    func addViewControllersToTabBar(){
        let homepageViewController = HomepageViewController()
        homepageViewController.title = "Homepage".localized
        homepageViewController.tabBarItem = UITabBarItem.init(title: "Homepage".localized, image: UIImage(named: "home"), tag: 0)
        
        let busStationViewController = BusStationsViewController()
        busStationViewController.title = "Stations".localized
        busStationViewController.tabBarItem = UITabBarItem.init(title: "Stations".localized, image: UIImage(named: "station"), tag: 1)
        
        let checkBalanceViewController = CheckBalanceViewController()
        checkBalanceViewController.title = "Balance".localized
        checkBalanceViewController.tabBarItem = UITabBarItem.init(title: "Balance".localized, image: UIImage(named: "balance"), tag: 2)
        
        let dealersViewController = RoutesViewController()
        dealersViewController.title = "Routes".localized
        dealersViewController.tabBarItem = UITabBarItem.init(title: "Routes".localized, image: UIImage(named: "route"), tag: 3)
        
        let busGeolocationsViewController = LiveVehicleLocationsViewController()
        busGeolocationsViewController.title = "Busses".localized
        busGeolocationsViewController.tabBarItem = UITabBarItem.init(title: "Busses".localized, image: UIImage(named: "bus-location"), tag: 4)
        
        let controllerArray: [UIViewController] = [homepageViewController, busStationViewController, checkBalanceViewController, dealersViewController, busGeolocationsViewController]
        
        self.viewControllers = controllerArray.map{
            UINavigationController.init(rootViewController: $0)
        }
    }
    
}
