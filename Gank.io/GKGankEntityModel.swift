//
//  GKGankEntityModel.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKGankEntityModel: NSObject, NSCoding {

    var title: String?
    var gankID: String?
    var URL: NSURL?
    var who: String?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.gankID = aDecoder.decodeObjectForKey("gankID") as? String
        self.URL = aDecoder.decodeObjectForKey("URL") as? NSURL
        self.who = aDecoder.decodeObjectForKey("who") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.gankID, forKey: "gankID")
        aCoder.encodeObject(self.URL, forKey: "URL")
        aCoder.encodeObject(self.who, forKey: "who")
    }
    
}
