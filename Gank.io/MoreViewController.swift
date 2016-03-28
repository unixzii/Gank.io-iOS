//
//  MoreViewController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class MoreViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.tableView.registerNib(UINib(nibName: "GKMiscTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

        self.clearsSelectionOnViewWillAppear = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "通用"
        default:
            return nil
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? GKMiscTableViewCell

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell?.primaryLabel.text = "清空缓存"
            cell?.secondaryLabel.text = self.getCacheSize()
            break
        default:
            break
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            self.clearCache()
            self.clearSelectionOfTableView()
            break
        default:
            break
        }
    }
    
    func clearSelectionOfTableView() {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // MARK: - Logic for options
    
    func getCacheSize() -> String {
        guard let dir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first else { return "" }
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(dir) {
            let fileSize = (try! (fileManager.attributesOfItemAtPath(dir)["NSFileSize"])!) as! NSNumber
            let fileSizeInMiB = fileSize.longLongValue / 1024 / 1024
            return "\(fileSizeInMiB) MB"
        }
        
        return ""
    }
    
    func clearCache() {
        let fileManager = NSFileManager.defaultManager()
        
        if let dir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first {
            do {
                try fileManager.removeItemAtPath(dir)
            } catch {}
        }
        
        if let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
            do {
                try fileManager.removeItemAtPath(dir)
            } catch {}
        }
        
        if let dir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true).first {
            do {
                try fileManager.removeItemAtPath(dir)
            } catch {}
        }
    }

}
