//
//  SettingsTableViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-19.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI


class SettingsTableViewController: VTNestedTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Actions"
        } else if section == 1 {
            return "Links"
        } else {
            return "Credits"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else {
            return 3
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "address", for: indexPath)
            return cell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedback", for: indexPath)
            return cell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
            return cell
        } else if indexPath.section == 2 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "credit-me", for: indexPath)
            return cell
        } else if indexPath.section == 2 && indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "credit-napi", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "credit-glypho", for: indexPath)
            return cell
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let locationPicker = LocationPicker()
        
            locationPicker.pickCompletion = { location in
                // Do something with the location the user picked.
                
                let errorHelper = {
                    uiHelper.displayError(controller: self, title: "Error Setting Location", message: "Sorry, we encountered an error while trying to save your location. Please try again", actionTitle: nil, onAction: nil)
                }
                
                DispatchQueue.main.async {
                    
                    self.navigationController?.popViewController(animated: true)
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
                    
                    // Some way to reload all views
                    reloadAll()
                }
            }
            
            locationPicker.addBarButtons()
            
            let navigationController = UINavigationController(rootViewController: locationPicker)
            present(navigationController, animated: true, completion: nil)
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
            openEmail()
           
        } else if indexPath.section == 1 && indexPath.row == 0 {
            
            let url = URL(string: "http://yashmulki.me/votisor/")!
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
           
        }
        
    }
    

}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
   
    func openEmail() {
        let emailTitle = "Feedback"
        let messageBody = "Sent from Votify App V 1.0"
        let toRecipents = ["votifyproject@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}
