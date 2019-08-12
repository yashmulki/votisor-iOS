//
//  VTPollingTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-08.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTPollingTableViewCell: UITableViewCell {

    @IBOutlet var labelConstraint: NSLayoutConstraint!
    
    static let cpcImage = UIImage(named: "party-cpc")
    static let lpcImage = UIImage(named: "party-lpc")
    static let ndpImage = UIImage(named: "party-ndp")
    static let gpcImage = UIImage(named: "party-gpc")
    static let bqImage = UIImage(named: "party-bq")
    static let ppcImage = UIImage(named: "party-ppc")
    
    private let conservativeColor = UIColor(red: 18/255, green: 75/255, blue: 154/255, alpha: 1)
    private let liberalColor = UIColor(red: 239/255, green: 29/255, blue: 41/255, alpha: 1)
    private let ndpColor = UIColor(red: 243/255, green: 129/255, blue: 47/255, alpha: 1)
    private let greenColor = UIColor(red: 67/255, green: 156/255, blue: 61/255, alpha: 1)
    private let bqColor = UIColor(red: 18/255, green: 61/255, blue: 115/255, alpha: 1)
    private let ppcColor = UIColor(red: 8/255, green: 30/255, blue: 115/255, alpha: 1)
    
    private var timer: Timer?
    private var progress: CGFloat = 0
    private var desiredProgress: CGFloat = 0
    
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
        desiredProgress = CGFloat(pollingPCT / highest) * 100
        progressBar.progressValue = progress
        
        // If statements for party image and color
        switch party {
        case "Conservative Party of Canada":
            progressBar.barColor = conservativeColor
            partyImage.image = VTPollingTableViewCell.cpcImage
        case "Liberal Party of Canada":
            progressBar.barColor = liberalColor
             partyImage.image = VTPollingTableViewCell.lpcImage
        case "New Democratic Party":
            progressBar.barColor = ndpColor
             partyImage.image = VTPollingTableViewCell.ndpImage
        case "Green Party of Canada":
            progressBar.barColor = greenColor
            partyImage.image = VTPollingTableViewCell.gpcImage
        case "Bloc Québécois":
            progressBar.barColor = bqColor
            partyImage.image = VTPollingTableViewCell.bqImage
        case "People's Party of Canada":
            progressBar.barColor = ppcColor
            partyImage.image = VTPollingTableViewCell.ppcImage
        default:
            print("Incorrect Party Name Configuration")
        }

        self.layoutIfNeeded()
        
    }
    
    func animate() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { (timer) in
            if self.progress + 0.5 >= self.desiredProgress {
                timer.invalidate()
            }
            self.progress += 0.5
            self.progressBar.progressValue = self.progress
            self.progressBar.setNeedsDisplay()
           
        })
    }
    
}
