//
//  RepresentativeDetailViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-17.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit

class RepresentativeDetailViewController: UIViewController {

    @IBOutlet var table: UITableView!
    var representative: Representative?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
    }
    
}

extension RepresentativeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representative?.position == "MP" ? 3 + (representative?.votes!.count)! : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "map", for: indexPath)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "divider", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "vote", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 151
        case 1:
            return 211
        case 2:
            return 44
        default:
            return 95
        }
    }
    
    
}
