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
            
            let errorHelper = {
                uiHelper.displayError(controller: self, title: "Error Setting Location", message: "Sorry, we encountered an error while trying to save your location. Please try again", actionTitle: nil, onAction: nil)
            }
            
            DispatchQueue.main.async {
                guard let latitude = location.coordinate?.latitude, let longitude = location.coordinate?.longitude else {
                    errorHelper()
                    return
                }
                
                let loc = Location(lat: latitude, long: longitude)
                let encoder = JSONEncoder()
                do {
                    let locData = try encoder.encode(loc)
                    UserDefaults.standard.set(locData, forKey: "loc")
                    currentLocation = loc
                } catch {
                    errorHelper()
                    return
                }
              
                
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.switchToFeed()
            }
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
