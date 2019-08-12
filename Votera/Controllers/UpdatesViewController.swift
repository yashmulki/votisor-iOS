//
//  FirstViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class UpdatesViewController: VTSwitchableViewController {

    @IBOutlet var table: UITableView!
    
    
    private var displayingNews = true
    private var articles: [NewsArticle] = [NewsArticle(title: "Trudeau taps outgoing NDP to chair new national security oversight body", description: "Prime Minister Justin Trudeau has appointed outgoing Victoria NDP MP Murray Rankin as chair of the new National Security and Intelligence Review Agency. (Mathieu Thériault/CBC)", source: "CBC News", imageURL: "https://i.cbc.ca/1.5241061.1565305537!/fileImage/httpImage/image.jpg_gen/derivatives/16x9_780/cf-18.jpg", articleURL: "yote.org"), NewsArticle(title: "Hello World", description: "World World Hello World", source: "CBC News", imageURL: "https://i.cbc.ca/1.5241061.1565305537!/fileImage/httpImage/image.jpg_gen/derivatives/16x9_780/cf-18.jpg", articleURL: "yote.org"), NewsArticle(title: "Hello World", description: "World World Hello World", source: "CBC News", imageURL: "https://i.cbc.ca/1.5241061.1565305537!/fileImage/httpImage/image.jpg_gen/derivatives/16x9_780/cf-18.jpg", articleURL: "yote.org"), NewsArticle(title: "Hello World", description: "World World Hello World", source: "CBC News", imageURL: "https://i.cbc.ca/1.5241061.1565305537!/fileImage/httpImage/image.jpg_gen/derivatives/16x9_780/cf-18.jpg", articleURL: "yote.org"), NewsArticle(title: "Hello World", description: "World World Hello World", source: "CBC News", imageURL: "https://i.cbc.ca/1.5241061.1565305537!/fileImage/httpImage/image.jpg_gen/derivatives/16x9_780/cf-18.jpg", articleURL: "yote.org"), ]
    
    
    // Stored as ordered by polling %
    private var polling: [PollItem] = [PollItem(party: "Conservative Party of Canada", pollingPCT: 34.5), PollItem(party: "Liberal Party of Canada", pollingPCT: 31.5), PollItem(party: "New Democratic Party", pollingPCT: 15.0), PollItem(party: "Green Party of Canada", pollingPCT: 12.0), PollItem(party: "Bloc Québécois", pollingPCT: 4.2), PollItem(party: "People's Party of Canada", pollingPCT: 2.7), ]
    private var highest: Double = 34.5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up VTSwitchableViewController
        let segments = ["News", "Polling"]
        let onChange =  { (segment: String) in
            if (segment == "NEWS") {
                self.displayingNews = true
                self.table.separatorStyle = .singleLine
            } else {
                self.displayingNews = false
                self.table.separatorStyle = .none
            }
            self.table.reloadData()
        }
        configure(segments: segments, onChange: onChange) // Configure the switchable view controler
        
        // Set up table
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }


}

extension UpdatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = displayingNews ? articles.count : polling.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if displayingNews {
            var cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as! VTNewsTableViewCell
            cell.configure(article: articles[indexPath.row])
            // Configure cell here
            return cell
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "polling", for: indexPath) as! VTPollingTableViewCell
        cell.configure(item: polling[indexPath.row], highest: highest)
        // Configure cell here
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = displayingNews ? 375 : 71.0
        return CGFloat(height)
    }
    
    
}

// Manages fetching for news
extension UpdatesViewController {
    
    
    
}
