//
//  OnboardingViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-13.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBAction func launchPicker(_ sender: Any) {
        let locationPicker = LocationPicker()
        locationPicker.pickCompletion = { location in
            // Do something with the location the user picked.
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "logged", sender: self)
            })
        }
       locationPicker.addBarButtons()
        
        let navigationController = UINavigationController(rootViewController: locationPicker)
        present(navigationController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
