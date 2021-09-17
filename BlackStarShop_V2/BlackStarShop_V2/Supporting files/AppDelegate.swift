//
//  AppDelegate.swift
//  BlackStarShop_V2
//
//  Created by Norik on 28.07.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shared = AppDelegate()
    lazy var dataStoreManager: DataStoreManager = DataStoreManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        let firstController = CategoriesViewController()
        let firstControllerForTabBarController = UINavigationController(rootViewController: firstController)
        firstControllerForTabBarController.navigationBar.barTintColor = .white
        let secondController = CartViewController()
        let secondControllerForTabBarController = UINavigationController(rootViewController: secondController)
        secondControllerForTabBarController.navigationBar.barTintColor = .mainColor
        tabBarController.viewControllers = [firstControllerForTabBarController, secondControllerForTabBarController]
        firstControllerForTabBarController.tabBarItem.image = UIImage(systemName: "cart")
        secondControllerForTabBarController.tabBarItem.image = UIImage(systemName: "cart.fill")
        var q = 0
        let _ = dataStoreManager.getItems().map {
            q += Int($0.quantity)
        }
        
        if q > 0 {
            secondControllerForTabBarController.tabBarItem.badgeValue = String(q)
        }
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}

