//
//  VTNavigationBar.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTNavigationBar: UINavigationBar {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 55)
    }
}
