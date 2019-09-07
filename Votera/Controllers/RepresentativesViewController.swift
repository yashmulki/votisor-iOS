//
//  RepresentativesViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-13.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import MapKit

class RepresentativesViewController: VTViewController, Reloadable {

    @IBAction func settings(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: self)
    }
    @IBOutlet var table: UITableView!
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    private var selectedRep: Representative?
//    var representatives: [Representative] = [Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: [Vote(title: "John Doe Act", decision: "Voted Yes")]), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), ]
    
    var representatives: [Representative] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        
        downloadCandidates()
        controllers.append(self)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? RepresentativeDetailViewController {
            des.representative = selectedRep!
        }
    }
 
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if selectedRep != nil {
            return true
        }
        return false
    }

}

extension RepresentativesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representatives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "map", for: indexPath) as! VTMapTableViewCell
            
            if let currentLocation = currentLocation {
                cell.configure(location: CLLocationCoordinate2DMake(currentLocation.lat, currentLocation.long))
            } else {
                cell.configure(location: CLLocationCoordinate2DMake(45.524, -73.596))
            }
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "representative", for: indexPath) as! VTRepresentativeTableViewCell
        cell.configure(rep: representatives[indexPath.row - 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = indexPath.row == 0 ? 294 : 99
        return height
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            selectedRep = representatives[indexPath.row - 1]
            performSegue(withIdentifier: "representative", sender: self)
        }
    }
    
}

extension RepresentativesViewController {
    
    @objc internal func refreshData() {
        downloadCandidates()
    }
    
    internal func hardRefresh() {
        self.representatives = []
        table.reloadData()
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        refreshData()
    }
    
    private func downloadCandidates() {
        let errorHandler = {
            self.refreshControl.endRefreshing()
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            uiHelper.displayError(controller: self, title: "Error Getting Representatives Data", message: "We're sorry, but we're having an issue fetching representatives data. Please reload or try again later. Ensure that you have an active internet connection", actionTitle: "Reload", onAction: { (action) in
                self.downloadCandidates()
            })
        }
        
        guard let currentLocation = currentLocation else {
            errorHandler()
            return
        }
        let endpoint = "http://130.211.124.161:10101/representatives?latitude=\(currentLocation.lat)&longitude=\(currentLocation.long)"
        
        APIManager.request(endpoint: endpoint) { (data, error) in
            guard let data = data, error == nil else {
                errorHandler()
                return
            }
            do {
                let json = try JSON(data: data)
                guard let representatives = json["representatives"].array else {
                    errorHandler()
                    return
                }
                var processedRepresentatives: [Representative] = []
                for representative in representatives {
                    
                    // Common with candidates
                    guard let name = representative["name"].string, let position = representative["position"].string else {
                        errorHandler()
                        return
                    }
                    let party = representative["party"].string ?? "No Party"
                    var image = representative["imageURL"].string!
                    if image == "" {
                        image = "https://journeypurebowlinggreen.com/wp-content/uploads/2018/05/placeholder-person.jpg"
                    }
                    let website = representative["website"].string ?? "none"
                    let twitter = representative["twitter"].string ?? "none"
                    let facebook = representative["facebook"].string ?? "none"
                    let email = representative["email"].string ?? "none"
                    let district = representative["district"].string!
                    
                    var processedOffices: [Office] = []
                    // Other attributes
                    if let offices = representative["offices"].array {
                        for office in offices {
                            let type = office["type"].string
                            let address = office["postal"].string
                            let telephone = office["tel"].string
                            let processedOffice = Office(type: type, address: address, tel: telephone)
                            processedOffices.append(processedOffice)
                        }
                    }
                    
                    var processedVotes: [Vote] = []
                    if let votes = representative["voting-record"].array {
                        for vote in votes {
                            let title = vote["title"].string
                            let decision = vote["decision"].string
                            let processedVote = Vote(title: title, decision: decision)
                            processedVotes.append(processedVote)
                        }
                    }
                    
                    let processedRepresentative = Representative(name: name, imageURL: image, email: email, web: website, twitter: twitter, facebook: facebook, position: position, offices: processedOffices, votes: processedVotes, party: party, district: district)
                    processedRepresentatives.append(processedRepresentative)
                }
                
                processedRepresentatives.append(Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: [], votes: [], party: "CPC", district: "Oakville"))
                
                // Add to the data source and reload table
                self.representatives = processedRepresentatives
                
            
                self.table.reloadData()
                self.refreshControl.endRefreshing()
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            } catch {
                errorHandler()
            }
        }
        
    }
    
}
