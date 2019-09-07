//
//  UIManager.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-12.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

let uiHelper = UIHelper()

class UIHelper: NSObject {
 
    func displayError(controller: UIViewController, title: String, message: String, actionTitle: String?, onAction: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actionTitle = actionTitle {
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: onAction))
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
             controller.present(alert, animated: true, completion: nil)
        }
        
       
    }
    
}
