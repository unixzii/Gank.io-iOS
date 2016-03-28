//
//  GKGankController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

typealias ItemTapHandler = GKGankEntityModel -> Void

class GKGankController: NSObject, UITableViewDelegate, UITableViewDataSource {

    var pageModel: GKGankPageModel?
    var itemTapHandler: ItemTapHandler?
    
    func gankEntityAtIndexPath(indexPath: NSIndexPath) -> GKGankEntityModel {
        // FIXME: There is too much reduplicate code.
        //        I think it needs refactor, suck!!
        
        let categories = (self.pageModel?.categories)!
        let category = categories.objectAtIndex(indexPath.section) as! GKGankCategoryModel
        let entity = category.entities?.objectAtIndex(indexPath.row) as! GKGankEntityModel
        
        return entity
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.pageModel != nil {
            guard let categories = self.pageModel?.categories else { return 0 }
            return categories.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.pageModel != nil {
            guard let categories = self.pageModel?.categories else { return nil }
            return (categories.objectAtIndex(section) as? GKGankCategoryModel)?.title
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.pageModel != nil {
            guard let categories = self.pageModel?.categories else { return 0 }
            let number = (categories.objectAtIndex(section) as? GKGankCategoryModel)?.entities?.count
            
            return number ?? 0
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! GKGankTableViewCell
        
        let categories = (self.pageModel?.categories)!
        let category = categories.objectAtIndex(indexPath.section) as! GKGankCategoryModel
        let entity = category.entities?.objectAtIndex(indexPath.row) as! GKGankEntityModel
        
        cell.titleLabel.text = entity.title
        cell.whoLabel.text = entity.who
        cell.backgroundColor = UIColor(white: 1, alpha: 0.4)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let string = NSString(string: self.gankEntityAtIndexPath(indexPath).title!)
        let attrs = [NSFontAttributeName:UIFont.systemFontOfSize(16)]
        return string.boundingRectWithSize(CGSize(width: tableView.bounds.width, height: 0), options: [.UsesFontLeading, .UsesLineFragmentOrigin], attributes: attrs, context: nil).height + 42
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.itemTapHandler != nil {
            self.itemTapHandler!(self.gankEntityAtIndexPath(indexPath))
        }
    }
    
}
