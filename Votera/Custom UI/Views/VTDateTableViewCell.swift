//
//  VTDateTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-12.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTDateTableViewCell: UITableViewCell {

    var onAddToCalendar: (() -> Void)?
    
    @IBOutlet var dateLabel: UILabel!
    @IBAction func addToCalendar(_ sender: Any) {
        onAddToCalendar!()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        var dateString = formatter.string(from: date).uppercased()
        dateLabel.text = dateString
    }

}
