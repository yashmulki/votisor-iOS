//
//  CandidateTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-13.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTCandidateTableViewCell: UITableViewCell {
    
    private var candidate: Candidate!
    private var urlOpener: ((String) -> Void)!

    @IBOutlet var photoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var partyLabel: UILabel!
    
    @IBOutlet var facebook: UIButton!
    @IBOutlet var twitter: UIButton!
    @IBOutlet var web: UIButton!
    
    @IBAction func openFB(_ sender: Any) {
        urlOpener(candidate.facebook)
    }
    
    @IBAction func openTW(_ sender: Any) {
        urlOpener(candidate.twitter)
    }
    
    @IBAction func openWB(_ sender: Any) {
        urlOpener(candidate.web)
    }
    
    func configure(candidate: Candidate, urlOpener: @escaping(String) -> Void) {
        
        photoView.layer.cornerRadius = photoView.frame.size.height/2
        photoView.clipsToBounds = true
        
        self.candidate = candidate
        self.urlOpener = urlOpener
        photoView.imageFromServerURL(candidate.imageURL, placeHolder: UIImage(named: "placeholder"))
        nameLabel.text = candidate.name
        partyLabel.text = candidate.party
        
        if candidate.facebook == "none" {
            facebook.removeFromSuperview()
        } else if candidate.twitter == "none" {
            twitter.removeFromSuperview()
        } else if candidate.web == "none" {
            web.removeFromSuperview()
        }
    }
    
}
