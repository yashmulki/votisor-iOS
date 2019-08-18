//
//  VTTabBarController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
}
