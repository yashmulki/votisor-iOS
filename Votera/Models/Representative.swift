//
//  Representative.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-17.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import Foundation

struct Representative {
    var name: String
    var imageURL: String
    var email: String
    var web: String
    var twitter: String
    var facebook: String
    var position: String
    var offices: [Office]
    var votes: [Vote]
    var party: String
    var district: String
}

struct Office {
    var type: String?
    var address: String?
    var tel: String?
}

struct Vote {
    var title: String?
    var decision: String?
}
