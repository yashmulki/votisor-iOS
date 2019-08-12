//
//  SecondViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-03.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import EventKit

class ElectionViewController: VTViewController {
    
    @IBOutlet var table: UITableView!
    
    
    var candidates: [Candidate] = [Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe")]
    
    @IBAction func addToCalendar(_ sender: Any) {
        addToCalendar()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        table.dataSource = self
        table.delegate = self
        table.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }


}

extension ElectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
   
}

extension ElectionViewController {
    
    private func addToCalendar() {
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = "2019 Federal Election"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "Remember to vote in the federal election - visit votera.org for more"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                
                print("failed to save event with error : \(error) or access not granted")
            }
        }
    }
}

