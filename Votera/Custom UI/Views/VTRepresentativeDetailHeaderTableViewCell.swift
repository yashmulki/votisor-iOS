//
//  VTRepresentativeDetailHeaderTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-19.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTRepresentativeDetailHeaderTableViewCell: UITableViewCell {

    private var representative: Representative!
       private var urlOpener: ((String) -> Void)!
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var role: UILabel!
    
    
    @IBOutlet var facebook: UIButton!
    @IBOutlet var twitter: UIButton!
    @IBOutlet var web: UIButton!
    
    @IBAction func openFacebook(_ sender: Any) {
        urlOpener(representative.facebook)
    }
    
    @IBAction func openTwitter(_ sender: Any) {
        urlOpener(representative.twitter)
    }
    
    @IBAction func openWeb(_ sender: Any) {
        urlOpener(representative.web)
    }
    
    func configure(representative: Representative, urlOpener: @escaping(String) -> Void) {
        
        self.representative = representative
        name.text = representative.name
        self.urlOpener = urlOpener
        
        if representative.position == "Mayor" {
            role.text = (representative.position + " of " + representative.district).uppercased()
        } else {
            role.text = (representative.position + " for " + representative.district).uppercased()
        }
        
        photo.layer.cornerRadius = photo.frame.size.height/2
        photo.clipsToBounds = true
        photo.imageFromServerURL(representative.imageURL, placeHolder: UIImage(named: "placeholder"))
        
        if representative.facebook == "none" {
            facebook.isEnabled = false
        }
        if representative.twitter == "none" {
            twitter.isEnabled = false
        }
        if representative.web == "none" || representative.web == ""{
            web.isEnabled = false
        }
        
    }
    
   
    
    
}
