//
//  VTTabBarController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTTabBarController: UITabBarController {

//    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "SplashIcon")!,iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: StyleConstants.vtRed)
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        // Set tab bar color
        tabBar.tintColor = StyleConstants.vtRed
        
        // Set up tab bar customizations
       // removeTabbarItemsText()
        
    }
    
    /// Removes text from tab bar items and changes image insets
    func removeTabbarItemsText() {
        if let items = tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
            }
        }
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        let newTabBarHeight = defaultTabBarHeight + 5
//
//        var newFrame = tabBar.frame
//        newFrame.size.height = newTabBarHeight
//        newFrame.origin.y = view.frame.size.height - newTabBarHeight
//
//        tabBar.frame = newFrame
//    }
    
}
