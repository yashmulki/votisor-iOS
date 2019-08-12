//
//  VTPollingTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-08.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTPollingTableViewCell: UITableViewCell {

    static let cpcImage = UIImage(named: "party-cpc")
    static let lpcImage = UIImage(named: "party-lpc")
    static let ndpImage = UIImage(named: "party-ndp")
    static let gpcImage = UIImage(named: "party-gpc")
    static let bqImage = UIImage(named: "party-bq")
    static let ppcImage = UIImage(named: "party-ppc")
    
    @IBOutlet var partyLabel: UILabel!
    @IBOutlet var progressDisplay: UILabel!
    @IBOutlet var progressBar: LinearProgressBar!
    @IBOutlet var partyImage: UIImageView!
    
    var party: String!
    var pollingPCT: Double!

    func configure(item: PollItem, highest: Double) {
        self.party = item.party
        self.pollingPCT = item.pollingPCT
        
        // Configure interface
        partyLabel.text = party.uppercased()
        progressDisplay.text = "\(pollingPCT!)%"
        let progress = CGFloat(pollingPCT / highest) * 100
        progressBar.progressValue = progress

        // If statements for party image and color
        switch party {
        case "Conservative Party of Canada":
            progressBar.barColor = UIColor.blue
            partyImage.image = VTPollingTableViewCell.cpcImage
        case "Liberal Party of Canada":
            progressBar.barColor = UIColor.red
             partyImage.image = VTPollingTableViewCell.lpcImage
        case "New Democratic Party":
            progressBar.barColor = UIColor.orange
             partyImage.image = VTPollingTableViewCell.ndpImage
        case "Green Party of Canada":
            progressBar.barColor = UIColor.green
            partyImage.image = VTPollingTableViewCell.gpcImage
        case "Bloc Québécois":
            progressBar.barColor = UIColor.blue
            partyImage.image = VTPollingTableViewCell.bqImage
        case "People's Party of Canada":
            progressBar.barColor = UIColor.purple
            partyImage.image = VTPollingTableViewCell.ppcImage
        default:
            print("Incorrect Party Name Configuration")
        }
        
    }
    
}
