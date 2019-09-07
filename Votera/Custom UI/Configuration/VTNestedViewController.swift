//
//  VTNestedViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-20.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
class VTNestedViewController: UIViewController {
    
    var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the title left aligned and set the font
        titleLabel = UILabel()
        let text = self.navigationItem.title?.uppercased()
        titleLabel!.text = text
        titleLabel!.sizeToFit()
        self.navigationItem.title = nil
        
        titleLabel!.font = UIFont(name: "AvenirNext-Bold", size: 18)
        titleLabel!.textColor = .darkGray
  
        self.navigationItem.titleView = titleLabel
        
    }
    
    func postInitConfig() {
        // Make the title left aligned and set the font
        titleLabel = UILabel()
        let text = self.navigationItem.title?.uppercased()
        titleLabel!.text = text
        titleLabel!.sizeToFit()
        self.navigationItem.title = nil
        
        titleLabel!.font = UIFont(name: "AvenirNext-Bold", size: 18)
        titleLabel!.textColor = .darkGray
        
        self.navigationItem.titleView = titleLabel
    }
    
    
    
}
