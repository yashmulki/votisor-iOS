//
//  OrganizeViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-10.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import Contacts

class OrganizeViewController: VTViewController {

    var hasPermissions = false
    
    @IBOutlet var permissionsView: UIView!
    @IBAction func contactsAccess(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}


//extension OrganizeViewController {
//    private func getContacts() {
//        var contacts = [CNContact]()
//        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
//        let request = CNContactFetchRequest(keysToFetch: keys)
//
//        do {
////            try self.contactStore.enumerateContactsWithFetchRequest(request) {
////                (contact, stop) in
////                // Array containing all unified contacts from everywhere
////                contacts.append(contact)
//            }
//        }
//        catch {
//            print("unable to fetch contacts")
//        }
//    }
//}
