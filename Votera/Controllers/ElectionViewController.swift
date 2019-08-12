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

    @IBOutlet var collection: UICollectionView!
    
    var candidates: [Candidate] = [Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe"), Candidate(name: "Jane Doe", imageURL: "jane.com", party: "Conservative Party of Canada", web: "janedoe.org", twitter: "twitter.com/janedoe", facebook: "facebook.com/janedoe")]
    
    @IBAction func addToCalendar(_ sender: Any) {
        addToCalendar()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collection.dataSource = self
        collection.delegate = self
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }


}

extension ElectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return candidates.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar", for: indexPath)
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "divider", for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "candidate", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionViewLayout.collectionViewContentSize.width
        
        var height = 228
        if indexPath.row == 0 {
            height = 200
        } else if indexPath.row == 1 {
            height = 50
        }
        
        return CGSize(width: width, height: height)
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

