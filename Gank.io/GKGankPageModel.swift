//
//  GKGankPageModel.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKGankPageModel: NSObject, NSCoding {

    var date: String?
    var categories: NSMutableArray?
    var fuliEntity: GKGankEntityModel?
    
    override init() {
        super.init()
        
        self.categories = NSMutableArray()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObjectForKey("date") as? String
        self.categories = aDecoder.decodeObjectForKey("categories") as? NSMutableArray
        self.fuliEntity = aDecoder.decodeObjectForKey("fuli") as? GKGankEntityModel
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.categories, forKey: "categories")
        aCoder.encodeObject(self.fuliEntity, forKey: "fuli")
    }
    
}