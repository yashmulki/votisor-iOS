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
        sourceImageView.layer.cornerRadius = 8.0
        sourceImageView.clipsToBounds = true
        
        var image = UIImage(named: "newsSource-cbc")
        
        switch article.source {
        case "Macleans.ca":
            image = UIImage(named: "newsSource-macleans")
        case "Globalnews.ca":
            image = UIImage(named: "newsSource-globalNews")
        case "Thestar.com":
            image = UIImage(named: "newsSource-torstar")
        case "Nationalpost.com":
            image = UIImage(named: "newsSource-natpost")
        case "The Globe And Mail":
            image = UIImage(named: "newsSource-globe")
        case "montrealgazette.com":
            image = UIImage(named: "newsSource-montgazette")
        case "Financialpost.com":
            image = UIImage(named: "newsSource-finpost")
        case "Nationalobserver.com":
            image = UIImage(named: "newsSource-natobserver")
        case "Huffingtonpost.ca":
            image = UIImage(named: "newsSource-natobserver")
        default:
            break
        }
        
        sourceImageView.image = image
        
    }
    
    func articleURL() -> URL? {
        let address = article.articleURL
        guard let url = URL(string: address) else {
            return nil
        }
        return url
    }

}
