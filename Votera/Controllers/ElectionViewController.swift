//
//  SecondViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import EventKit
import SafariServices

class ElectionViewController: VTViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
     private var safariVC: SFSafariViewController?
    
//    var candidates: [Candidate] = [Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "http://facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe")]
    var candidates: [Candidate] = []
    private var electionDate: Date = Date(timeIntervalSince1970: 1571616000) // October 21, 2019
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        table.dataSource = self
        table.delegate = self
        table.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        downloadCandidates()
    }


}

extension ElectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! VTDateTableViewCell
            cell.configure(date: self.electionDate)
            cell.onAddToCalendar = { [weak self] in
                self?.addToCalendar()
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "divider", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "candidate", for: indexPath) as! VTCandidateTableViewCell
            cell.configure(candidate: candidates[indexPath.row - 2]) { [weak self] (url) in
                guard let address = URL(string: url) else {
                    return
                }
                self?.safariVC = SFSafariViewController(url: address)
                guard let safariVC = self?.safariVC else {
                    return
                }
                self?.present(safariVC, animated: true, completion: nil)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 156
        case 1:
            return 44
        default:
            return 157
        }
    }
   
}

extension ElectionViewController {
    
    @objc private func refreshData() {
        downloadCandidates()
    }
    
    private func downloadCandidates() {
        let endpoint = "http://165.22.233.166:10101/election?latitude=45.524&longitude=-73.596"
        let errorHandler = {
            uiHelper.displayError(controller: self, title: "Error Getting Electio Data", message: "We're sorry, but we're having an issue fetching election data. Please reload or try again later", actionTitle: "Reload", onAction: { (action) in
                self.downloadCandidates()
            })
        }
        
        APIManager.request(endpoint: endpoint) { (data, error) in
            guard let data = data, error == nil else {
                errorHandler()
                return
            }
            do {
                let json = try JSON(data: data)
                guard let candidates = json["candidates"].array else {
                    errorHandler()
                    return
                }
                var processedCandidates: [Candidate] = []
                for candidate in candidates {
                    guard let name = candidate["name"].string else {
                        errorHandler()
                        return
                    }
                    let party = candidate["party"].string ?? "No Party"
                    var image = candidate["imageURL"].string!
                    
                    if image == "" {
                        image = "https://journeypurebowlinggreen.com/wp-content/uploads/2018/05/placeholder-person.jpg"
                    }
                    
                    let website = candidate["website"].string ?? "none"
                    let twitter = candidate["twitter"].string ?? "none"
                    let facebook = candidate["facebook"].string ?? "none"
                    
                    let processedCandidate = Candidate(name: name, imageURL: image, party: party, web: website, twitter: twitter, facebook: facebook)
                    processedCandidates.append(processedCandidate)
                }
                
                // Add to the data source and reload table
                self.candidates = processedCandidates
                
                // Get election date
                if let electionDateString = json["electionDate"].string {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let date = formatter.date(from: electionDateString)
                    self.electionDate = date ?? self.electionDate
                }
                
                
                self.table.reloadData()
                self.refreshControl.endRefreshing()
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            } catch {
                errorHandler()
            }
        }
        
    }
    
    
    private func addToCalendar() {
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = "2019 Federal Election"
                event.startDate = self.electionDate
                event.endDate = self.electionDate
                event.notes = "Remember to vote in the federal election - visit votera.org for more"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                uiHelper.displayError(controller: self, title: "Added Election", message: "We have added the election to your calendar", actionTitle: nil, onAction: nil)
                print("Saved Event")
            }
            else{
                 uiHelper.displayError(controller: self, title: "Couldn't Add Election", message: "We were unable to add the election to your calendar– check that calendar permissions have been granted in the Settings app", actionTitle: nil, onAction: nil)
                print("failed to save event with error : \(error) or access not granted")
            }
        }
    }
}

