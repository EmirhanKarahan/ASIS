//
//  AppNavigationController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit

final class AppNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        viewControllers = [HomepageTabBarController()]
    }
    
    private func setupNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
      
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
}
