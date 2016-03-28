//
//  GKGankCategoryModel.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKGankCategoryModel: NSObject, NSCoding {
    
    var title: String?
    var entities: NSMutableArray?
    
    override init() {
        super.init()
        
        self.entities = NSMutableArray()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.entities = aDecoder.decodeObjectForKey("entities") as? NSMutableArray
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.entities, forKey: "entities")
    }
    
}
