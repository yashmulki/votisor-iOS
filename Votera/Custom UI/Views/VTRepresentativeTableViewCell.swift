//
//  VTRepresentativeTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-19.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTRepresentativeTableViewCell: UITableViewCell {
    
    @IBOutlet var repImage: UIImageView!
    @IBOutlet var repName: UILabel!
    @IBOutlet var repPosition: UILabel!
    
    var representative: Representative?
    
    func configure(rep: Representative) {
        self.representative = rep
        
        repImage.layer.cornerRadius = repImage.frame.size.height/2
        repImage.clipsToBounds = true
    repImage.imageFromServerURL(representative!.imageURL, placeHolder: UIImage(named: "placeholder"))
        repName.text = representative!.name
        if representative!.position == "Mayor" {
            repPosition.text = (representative!.position + " of " + representative!.district).uppercased()
        } else {
            repPosition.text = (representative!.position + " for " + representative!.district).uppercased()
        }
       
    }
    
}
