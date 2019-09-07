//
//  VTVoteTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-19.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTVoteTableViewCell: UITableViewCell {

    @IBOutlet var voteDecision: UILabel!
    @IBOutlet var billName: UILabel!
    
    var vote: Vote!
    
    func configure(vote: Vote) {
        self.vote = vote
        
        guard let title = vote.title, let decision = vote.decision else {
            return
        }
        billName.text = title
        voteDecision.text = decision.uppercased()
        if decision == "Yes" {
            voteDecision.textColor = StyleConstants.vtGreen
        } else if decision == "No" {
            voteDecision.textColor = StyleConstants.vtRed
        } else {
            voteDecision.textColor = StyleConstants.vtOrange
        }
        
        
    }

}
