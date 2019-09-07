//
//  FirstViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import SafariServices

class UpdatesViewController: VTSwitchableViewController {
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var safariVC: SFSafariViewController?
    
    private var displayingNews = true
    private var articles: [NewsArticle] = []
    private var articlesCount: Int = 0
    
//    // Stored as ordered by polling %
//    private var polling: [PollItem] = [PollItem(party: "Conservative Party of Canada", pollingPCT: 34.5), PollItem(party: "Liberal Party of Canada", pollingPCT: 31.5), PollItem(party: "New Democratic Party", pollingPCT: 15.0), PollItem(party: "Green Party of Canada", pollingPCT: 12.0), PollItem(party: "Bloc Québécois", pollingPCT: 4.2), PollItem(party: "People's Party of Canada", pollingPCT: 2.7), ]
    
    private var polling: [PollItem] = []
    
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
        table.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        // Get data
        downloadArticles(offset: 0, limit: 15)
        downloadPolls()
        
        
    }


}

extension UpdatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = displayingNews ? articles.count : polling.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if displayingNews {
            let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as! VTNewsTableViewCell
            cell.configure(article: articles[indexPath.row])
            // Configure cell here
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "polling", for: indexPath) as! VTPollingTableViewCell
        cell.configure(item: polling[indexPath.row], highest: highest)
        cell.animate()
        // Configure cell here
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = displayingNews ? 375 : 71.0
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !displayingNews {
            return
        }
        
        let selectedItem = articles[indexPath.row]
        guard let url = URL(string: selectedItem.articleURL) else {
            return
        }
//        safariVC = SFSafariViewController(url: url)
//        present(safariVC!, animated: true, completion: nil)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 && indexPath.row < articlesCount - 1 && displayingNews{
            downloadArticles(offset: indexPath.row + 1, limit: 10)
        }
    }
    
    
}

// Manages fetching for news and polling
extension UpdatesViewController {
    
    @objc internal func refreshData() {
        
        if displayingNews {
           articles = []
           downloadArticles(offset: 0, limit: 15)
        } else {
            polling = []
            downloadPolls()
        }
        table.reloadData()
    }
    
    private func downloadArticles(offset: Int, limit: Int) {
        let endpoint = "http://130.211.124.161:10101/news?limit=\(limit)&offset=\(offset)"
        let errorHandler = {
            self.refreshControl.endRefreshing()
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            uiHelper.displayError(controller: self, title: "Error Getting Articles", message: "We're sorry, but we're having an issue fetching articles. Please reload or try again later. Ensure that you have an active internet connection", actionTitle: "Reload", onAction: { (action) in
                self.downloadArticles(offset: offset, limit: limit)
            })
        }
        APIManager.request(endpoint: endpoint) { (data, error) in
            guard let data = data, error == nil else {
                errorHandler()
                return
            }
            do {
                let json = try JSON(data: data)
                guard let articles = json["newsArticles"].array, let items = json["count"].int else {
                    errorHandler()
                    return
                }
                
                self.articlesCount = items
                
                var processedArticles: [NewsArticle] = []
                for article in articles {
                    guard let title = article["title"].string else {
                        errorHandler()
                        return
                    }
                    guard let source = article["source"]["name"].string else {
                        errorHandler()
                        return
                    }
                    guard let description = article["description"].string else {
                        errorHandler()
                        return
                    }
                    guard let articleURL = article["url"].string else {
                        errorHandler()
                        return
                    }
                    var imageURL = "https://imgplaceholder.com/350x225/ff7f7f/333333/fa-image"
                    if let imgURL = article["urlToImage"].string {
                        imageURL = imgURL
                    }
                    
                    let processedArticle = NewsArticle(title: title, description: description, source: source, imageURL: imageURL, articleURL: articleURL)
                    processedArticles.append(processedArticle)
                }
                
                // Add to the data source and reload table
                self.articles.append(contentsOf: processedArticles)
                self.table.reloadData()
                self.refreshControl.endRefreshing()
                
            self.loadingIndicator.startAnimating()
                self.loadingIndicator.isHidden = true
            } catch {
               errorHandler()
            }
        }
        
    }
    
    private func downloadPolls() {
        let endpoint = "http://130.211.124.161:10101/polling"
        let errorHandler = {
            uiHelper.displayError(controller: self, title: "Error Getting Polling", message: "We're sorry, but we're having an issue fetching polls. Please reload or try again later. Ensure that you have an active internet connection", actionTitle: "Reload", onAction: { (action) in
                self.downloadPolls()
            })
        }
        APIManager.request(endpoint: endpoint) { (data, error) in
            guard let data = data, error == nil else {
                errorHandler()
                return
            }
            do {
                let json = try JSON(data: data)
                guard let polling = json["polling"].dictionary else {
                    errorHandler()
                    return
                }
                
                guard let CPC = polling["CPC"]?.double else {
                    errorHandler()
                    return
                }
                
                
                guard let LPC = polling["LPC"]?.double else {
                    errorHandler()
                    return
                }
                
                
                guard let NDP = polling["NDP"]?.double else {
                    errorHandler()
                    return
                }
                
                guard let GPC = polling["GRN"]?.double else {
                    errorHandler()
                    return
                }
                
                guard let BQ = polling["BQ"]?.double else {
                    errorHandler()
                    return
                }
                
                guard let PPC = polling["PPC"]?.double else {
                    errorHandler()
                    return
                }
                
                let parties = ["Conservative Party of Canada", "Liberal Party of Canada", "New Democratic Party", "Green Party of Canada", "Bloc Québécois", "People's Party of Canada"]
                let values = [CPC, LPC, NDP, GPC, BQ, PPC]
               
                var (sParties, sValues) = self.partiesSortedByValue(parties: parties, values: values)
                sParties = sParties.reversed()
                sValues = sValues.reversed()
                
                for i in 0 ..< sParties.count {
                    let item = PollItem(party: sParties[i], pollingPCT: sValues[i])
                    self.polling.append(item)
                }
                
                self.highest = sValues[0]
                
                self.table.reloadData()
                self.refreshControl.endRefreshing()
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            } catch {
                errorHandler()
            }
        }
    }
    
    func partiesSortedByValue(parties: [String], values: [Double]) -> ([String], [Double]) {
        var p = parties
        var v = values
        for x in 1..<v.count {
            var y = x
            let temp = v[y]
            let party = p[y]
            while y > 0 && temp < v[y - 1] {
                v[y] = v[y - 1]
                p[y] = p[y-1]
                    y -= 1
            }
            v[y] = temp
            p[y] = party
        }
        return (p, v)
    }
    
}
