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
        title = "ASIS"
        addViewControllersToTabBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "burger-menu"), style: .plain, target: self, action: #selector(openSideMenu))
    }
    
    @objc func openSideMenu(){
        let menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
        menu.leftSide = true
        present(menu, animated: true, completion: nil)
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
        
        let checkBalanceViewController = CheckBalanceViewController()
        checkBalanceViewController.title = "Balance".localized
        checkBalanceViewController.tabBarItem = UITabBarItem.init(title: "Balance".localized, image: UIImage(named: "balance"), tag: 1)
        
        let routesViewController = RoutesViewController()
        routesViewController.title = "Routes".localized
        routesViewController.tabBarItem = UITabBarItem.init(title: "Routes".localized, image: UIImage(named: "route"), tag: 2)
        
        let howToGoController = HowToGoViewController()
        howToGoController.title = "How to Go?".localized
        howToGoController.tabBarItem = UITabBarItem.init(title: "How to Go?".localized, image: UIImage(named: "how-to-go"), tag: 3)
        
        let favoritesViewController = FavoritesTableViewController()
        favoritesViewController.title = "Favorites".localized
        favoritesViewController.tabBarItem = UITabBarItem.init(title: "Favorites".localized, image: UIImage(named: "favorites"), tag: 4)
        
        let controllerArray: [UIViewController] = [homepageViewController, routesViewController, howToGoController, checkBalanceViewController, favoritesViewController]
        
        self.viewControllers = controllerArray
    }
    
}
