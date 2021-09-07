//
//  MultiViewController.swift
//  BlackStarShop_V2
//
//  Created by Norik on 06.09.2021.
//  Copyright © 2021 Norik. All rights reserved.
//

import UIKit

protocol MultiViewProtocol {
    func countInfo() -> Int
    func getLabel(index: Int) -> String?
}

final class MultiViewController: UIViewController {
    
    //MARK: - Dependencies
    
    var myView: MultiView?
    weak var prevViewController: ItemViewController?
    
    //MARK: - Properties
    
    var info: [String?]
    var controllerType: String
    
    //MARK: - Init
    
    init(info: [String?], current prev: ItemViewController, str: String) {
        self.info = info
        controllerType = str
        super.init(nibName: nil, bundle: nil)
        prevViewController = prev
        myView = MultiView(viewController: self)
    }
    
    override func loadView() {
        super.loadView()
        view = myView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func delegate(index: Int) {
        if controllerType == "Color" {
            prevViewController?.currIndex = index
            prevViewController?.currImageIndex = 0
            prevViewController?.model?.imagesLoad(index: index, completion: {
                self.prevViewController?.myView?.reloadData()
                self.prevViewController?.myView?.updatePriceLabel()
                self.prevViewController?.myView?.updateColorsButtonTitle()
                self.prevViewController?.myView?.scrollTo(index: 0, animated: false)
                self.prevViewController?.myView?.checkAndHideLeftRightButtons(index: 0)
            })
        } else {
            if controllerType == "Size" {
                //
            }
        }
    }

}

extension MultiViewController: MultiViewProtocol {
    
    func countInfo() -> Int {
        return info.count
    }
    
    func getLabel(index: Int) -> String? {
        return info[index]
    }
}
