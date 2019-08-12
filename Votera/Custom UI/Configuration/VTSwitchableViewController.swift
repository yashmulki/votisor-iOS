//
//  VTSwitchableViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTSwitchableViewController: VTViewController {

    private var onChange: ((String) -> Void)!
    private var segments: [String] = []
    
    func configure(segments: [String], onChange: @escaping(String) -> Void) {
        
        self.onChange = onChange
        self.segments = segments
        
        // Create segmented control and add to navbar
        let segmentedControl = TTSegmentedControl(frame: CGRect(x: 50, y: 150, width: 150, height: 30))
        segmentedControl.useShadow = true
        segmentedControl.itemTitles = segments
        segmentedControl.allowChangeThumbWidth = false
        segmentedControl.cornerRadius = 5
        segmentedControl.thumbGradientColors = nil
        segmentedControl.thumbColor = StyleConstants.vtRed
        segmentedControl.containerBackgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        segmentedControl.didSelectItemWith = { (index, title) -> () in
            self.selectView(at: index)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: segmentedControl)
        let text = segments[0].uppercased()
        titleLabel?.text = text
    }
    
    private func selectView(at index: Int) {
        let text = segments[index].uppercased()
        titleLabel?.text = text
        onChange(text)
    }
    
}
