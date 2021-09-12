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
        
        UINavigationBar.appearance().isTranslucent = false
        
        let tabBarController = UITabBarController()
        let firstController = CategoriesViewController()
        firstController.title = "Категории"
//        firstController.navigationController?.navigationBar.backgroundColor = .mainColor
//        UINavigationBarAppearance().configureWithOpaqueBackground()
//        UINavigationBarAppearance().configureWithTransparentBackground()
//        firstController.navigationController?.navigationBar.isTranslucent = false
//        firstController.navigationController?.navigationBar.shadowImage = UIImage()
//        firstController.navigationController?.navigationBar.alpha = 1
//        firstController.navigationController?.view.backgroundColor = .mainColor
//        firstController.navigationController?.navigationBar.backgroundColor = .mainColor
        let firstControllerForTabBarController = UINavigationController(rootViewController: firstController)
        firstControllerForTabBarController.title = "Магазин"
        let secondController = CartViewController()
        secondController.title = "Корзина"
        let secondControllerForTabBarController = UINavigationController(rootViewController: secondController)
        secondControllerForTabBarController.title = "Корзина"
        tabBarController.viewControllers = [firstControllerForTabBarController, secondControllerForTabBarController]
//        tabBarController.tabBar.barTintColor = .mainColor
//        tabBarController.tabBar.alpha = 1
//        tabBarController.tabBar.trans
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}

