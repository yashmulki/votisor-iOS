//
//  VTNewsTableViewCell.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-08.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class VTNewsTableViewCell: UITableViewCell {

    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var sourceImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceName: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var article: NewsArticle!
    
    func configure(article: NewsArticle) {
        self.article = article
        // Configure Interface
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        sourceName.text = article.source
        
        // if statements for images
        articleImage.imageFromServerURL(article.imageURL, placeHolder: UIImage(named: "placeholder-image.png"))
        sourceImageView.image = UIImage(named: "newsSource-cbc.jpg")
        sourceImageView.layer.cornerRadius = 8.0
        sourceImageView.clipsToBounds = true
    }
    
    func articleURL() -> URL? {
        let address = article.articleURL
        guard let url = URL(string: address) else {
            return nil
        }
        return url
    }

}
