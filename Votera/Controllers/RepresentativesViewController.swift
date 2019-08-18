//
//  RepresentativesViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-13.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import MapKit

class RepresentativesViewController: VTViewController {

    @IBOutlet var table: UITableView!
    
    var representatives: [Representative] = [Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: [Vote(title: "John Doe Act", decision: "Voted Yes")]), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), Representative(name: "John Doe", imageURL: "www.jphn.com", email: "john@government.com", web: "john.com", twitter: "twitter.com/johb", facebook: "fb.john", position: "MP", offices: nil, votes: nil), ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? RepresentativeDetailViewController {
            des.representative = representatives[1]
        }
    }
 

}

extension RepresentativesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + representatives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "map", for: indexPath) as! VTMapTableViewCell
            cell.configure(location: CLLocationCoordinate2DMake(45.524, -73.596))
             return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "representative", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = indexPath.row == 0 ? 294 : 157
        return height
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "representative", sender: self)
    }
    
}
