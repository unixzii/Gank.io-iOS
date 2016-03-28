//
//  HistoryViewController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/28.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    var delegate: HistoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "干货历史"

        let doneBarItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(HistoryViewController.done))
        self.navigationItem.rightBarButtonItem = doneBarItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GKHistoryController.sharedController.availableHistoryDates.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }

        // Configure the cell...
        cell?.textLabel?.text = GKHistoryController.sharedController.availableHistoryDates[indexPath.row]
        if cell?.textLabel?.text == GKHistoryController.sharedController.selectedDate {
            cell?.accessoryType = .Checkmark
        } else {
            cell?.accessoryType = .None
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.done()
    }
    
    func done() {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.delegate?.historyDidSubmit(GKHistoryController.sharedController.availableHistoryDates[indexPath.row])
        } else {
            self.delegate?.historyDidSubmit(nil)
        }
    }

}

protocol HistoryViewControllerDelegate {
    
    func historyDidSubmit(history: String?)
    
}
