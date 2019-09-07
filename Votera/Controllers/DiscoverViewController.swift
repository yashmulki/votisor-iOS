//
//  DiscoverViewController.swift
//  Votera
//
//  Created by Yashvardhan Mulki on 2019-08-12.
//  Copyright © 2019 Yashvardhan Mulki. All rights reserved.
//

import UIKit
import SafariServices

class DiscoverViewController: VTViewController {

    @IBOutlet var table: UITableView!
    var safariVC: SFSafariViewController?
   
    let platformLinks = ["https://www.liberal.ca/realchange/" , "https://www.conservative.ca", "https://www.ndp.ca/commitments", "https://www.greenparty.ca/en/vision-green", "https://www.peoplespartyofcanada.ca/platform", "https://www.blocquebecois.org"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        table.delegate = self
    }
    
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "lpc"
        
        switch indexPath.row {
        case 1:
            identifier = "cpc"
        case 2:
            identifier = "ndp"
        case 3:
            identifier = "gpc"
        case 4:
            identifier = "ppc"
        case 5:
            identifier = "bq"
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: platformLinks[indexPath.row]) else {
            return
        }
        safariVC = SFSafariViewController(url: url)
        present(safariVC!, animated: true, completion: nil)
    }
    
}
