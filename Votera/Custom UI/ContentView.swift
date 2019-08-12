//
//  ContentView.swift
//  ProjectFusion
//
//  Created by Yashvardhan Mulki on 2017-07-23.
//  Copyright © 2017 yashmulki. All rights reserved.
//

import UIKit


@IBDesignable class contentView: UIView {
    @IBInspectable var cornRad: CGFloat = 0.0
    @IBInspectable var color:UIColor = UIColor.gray
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let pathOne = UIBezierPath(roundedRect: rect, cornerRadius: cornRad)
        color.setFill()
        UIColor.black.setStroke()
        pathOne.fill()
        self.backgroundColor = UIColor.clear
        
    }
    
}

