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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        let firstController = CategoriesViewController()
        let firstControllerForTabBarController = UINavigationController(rootViewController: firstController)
        firstControllerForTabBarController.title = "Магазин"
        firstControllerForTabBarController.navigationBar.barTintColor = .white
        let secondController = CartViewController()
        let secondControllerForTabBarController = UINavigationController(rootViewController: secondController)
        secondControllerForTabBarController.title = "Корзина"
        secondControllerForTabBarController.navigationBar.barTintColor = .mainColor
        tabBarController.viewControllers = [firstControllerForTabBarController, secondControllerForTabBarController]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}

