//
//  NewsArticle.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-08.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import Foundation

struct NewsArticle: Codable {
    var title: String
    var description: String
    var source: String
    var imageURL: String
    var articleURL: String
}
