//
//  Extensions.swift
//  BlackStarShop_V2
//
//  Created by Norik on 13.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

//MARK: - UIViewController: Changing colors of navigationBar and tabBar

extension UIViewController {
    func udpateNavigationBarAndTabBarBackgroundColor(color: UIColor?) {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.barTintColor = color
            self.tabBarController?.tabBar.barTintColor = color
        }
    }
}

//MARK: - UIСolor mainColor

extension UIColor {
    static var mainColor: UIColor {
        return UIColor(displayP3Red: 232/255, green: 231/255, blue: 255/255, alpha: 1)
    }
}

//MARK: - UIStackView backround

extension UIStackView {
    func addBackground(color: UIColor, cornerRadius: CGFloat? = 0) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subview.layer.cornerRadius = cornerRadius ?? 0
        insertSubview(subview, at: 0)
    }
}

//MARK: - RegularChecker

extension String {
    func matches(_ regex: String) -> Bool {
        return (self.range(of: regex, options: .regularExpression) != nil)
    }
}
