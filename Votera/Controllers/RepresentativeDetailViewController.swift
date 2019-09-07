//
//  RepresentativeDetailViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-17.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class RepresentativeDetailViewController: VTNestedViewController {
    
    private var safariVC: SFSafariViewController?
    private var phone: String = ""
    
    @IBOutlet var table: UITableView!
    var representative: Representative!
    // Header, Email, Voteheader, Votes
    private var items: [String] = ["Header"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        self.title = representative.name
        postInitConfig()
    }
    
}

extension RepresentativeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let representative = representative else {
            return 0
        }
        
        items = ["Header"]
        
        var rowCounter = 1
        let office = representative.offices.first(where: { (office) -> Bool in
            return office.address != nil
        })
        
        if representative.email != "none" {
            items.append("E-mail")
            rowCounter += 1
        }
        
        let phoneOffice = representative.offices.first(where: { (office) -> Bool in
            return office.tel != nil
        })
        
        if phoneOffice != nil {
            items.append("Phone")
            self.phone = phoneOffice!.tel!
            rowCounter += 1
        }
        
        if representative.party != "none" && representative.party != "" {
            items.append("Party")
            rowCounter += 1
        }
        
        // Office Map
        if office != nil {
            items.append("Map")
            rowCounter += 1
        }
        // Votes
        if representative.position == "MP" && representative.votes.count > 0 {
            items.append("Voteheader")
            items.append("Votes")
            rowCounter += representative.votes.count + 1
        }
        
        return rowCounter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var item = "Header"
        
        if indexPath.row >= items.count {
            item = items.last!
        } else {
            item = items[indexPath.row]
        }
        
        switch item {
        case "Header":
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! VTRepresentativeDetailHeaderTableViewCell
            cell.configure(representative: representative) { [weak self] (url) in
                guard let address = URL(string: url) else {
                    return
                }
                self?.safariVC = SFSafariViewController(url: address)
                guard let safariVC = self?.safariVC else {
                    return
                }
                self?.present(safariVC, animated: true, completion: nil)
            }
            return cell
        case "E-mail":
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
            cell.textLabel?.text = "E-Mail"
            cell.detailTextLabel?.text = representative.email
            return cell
        case "Phone":
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
            cell.textLabel?.text = "Phone"
            cell.detailTextLabel?.text = phone
            return cell
        case "Party":
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
            cell.textLabel?.text = "Party"
            cell.detailTextLabel?.text = representative.party
            return cell
        case "Map":
            let cell = tableView.dequeueReusableCell(withIdentifier: "map", for: indexPath) as! VTMapTableViewCell
            var office = representative.offices.first(where: { (office) -> Bool in
                return office.type == "constituency"
            })
            if office == nil {
                office = representative.offices.first
            }
            guard let address = office?.address else {
                return cell
            }
            cell.configureOffice(address: address)
            return cell
        case "Voteheader":
            let cell = tableView.dequeueReusableCell(withIdentifier: "divider", for: indexPath)
            return cell
        case "Votes":
            let cell = tableView.dequeueReusableCell(withIdentifier: "vote", for: indexPath) as! VTVoteTableViewCell
            let voteIndex = indexPath.row - items.count + 1
            cell.configure(vote: representative.votes[voteIndex])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! VTRepresentativeDetailHeaderTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var item = "Header"
        
        if indexPath.row >= items.count {
            item = items.last!
        } else {
            item = items[indexPath.row]
        }
      
        switch item {
        case "Header":
           return 118
        case "E-mail":
            return 44
        case "Phone":
            return 44
        case "Party":
            return 44
        case "Map":
            return 211
        case "Voteheader":
            return 44
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = "Header"
        
        if indexPath.row >= items.count {
            item = items.last!
        } else {
            item = items[indexPath.row]
        }
        
        switch item {
        case "E-mail":
            openEmail()
        case "Phone":
            guard let number = URL(string: "tel://" + phone.replacingOccurrences(of: " ", with: "")) else { return }
            
            if UIApplication.shared.canOpenURL(number) {
                UIApplication.shared.open(number)
            }
        default:
            break
        }    }
    
    
}

extension RepresentativeDetailViewController: MFMailComposeViewControllerDelegate {
    
    func openEmail() {
        let emailTitle = ""
        let messageBody = "Sent through the Votisor App"
        let toRecipents = [representative.email]
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
