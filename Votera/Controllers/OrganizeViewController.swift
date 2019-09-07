//
//  OrganizeViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-10.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class OrganizeViewController: VTViewController, MFMessageComposeViewControllerDelegate {
  
    var contacts: [CNContact] = []
    
    private var messageVC: MFMessageComposeViewController?
    @IBOutlet var table: UITableView!
    @IBOutlet var permissionsView: UIView!
    @IBAction func contactsAccess(_ sender: Any) {
      initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        if UserDefaults.standard.object(forKey: "contPerm") != nil {
            initialize()
        }
        
    }
    
    func initialize() {
        let fetched = PhoneContacts.getContacts()
        if !fetched.isEmpty {
            UserDefaults.standard.set("done", forKey: "contPerm")
            permissionsView.isHidden = true
            contacts = fetched
            table.reloadData()
        } else {
            UserDefaults.standard.removeObject(forKey: "contPerm")
            permissionsView.isHidden = false
        }
    }
    
    func sendMessage(recipient: String) {
        if MFMessageComposeViewController.canSendText() {
            messageVC = MFMessageComposeViewController()
            messageVC!.body = "Voting is very important! Remember to vote this October 20th in the Canadian Federal Election. Visit yashmulki.me/votisor for more";
            messageVC!.recipients = [recipient]
            messageVC?.messageComposeDelegate = self
            self.present(messageVC!, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if result == .cancelled {
            messageVC?.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension OrganizeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath)
        let item = contacts[indexPath.row]
        cell.textLabel?.text = "\(item.givenName) \(item.familyName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var phoneNumber = contacts[indexPath.row].phoneNumbers.first { (phone) -> Bool in
            return phone.label == "CNLabelPhoneNumberMobile"
        }
        
        if phoneNumber == nil {
            phoneNumber = contacts[indexPath.row].phoneNumbers.first
        }
        
        guard let value = phoneNumber?.value.stringValue else {
            uiHelper.displayError(controller: self, title: "Error Loading Contact", message: "Please verify the contact is configured correctly", actionTitle: nil, onAction: nil)
            return
        }
        sendMessage(recipient: value)
    }
    
}



class PhoneContacts {
    
    class func getContacts() -> [CNContact] { //  ContactsFilter is Enum find it below
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results
    }
}
