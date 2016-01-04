//
//  TableController.swift
//  Test
//
//  Created by Sergey Kolupaev on 12/29/15.
//  Copyright © 2015 Sergey Kolupaev. All rights reserved.
//

import UIKit

class TableController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 10
        case 1:
            return 20
        default:
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            if let cell = tableView.dequeueReusableCellWithIdentifier("LabelIdentifier") as? LabelCell {
                cell.label?.text = "Label \(indexPath.section) at \(indexPath.row)"
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCellWithIdentifier("ViewIdentifier") as? ViewCell {
                cell.label?.text = "View \(indexPath.section) at \(indexPath.row)"
                var s = ""
                for i in 0..<indexPath.row {
                    s.appendContentsOf("\(i+1)\n")
                }
                cell.textView?.text = s
                return cell
            }
            
        }
        
        return UITableViewCell()
    }
}
