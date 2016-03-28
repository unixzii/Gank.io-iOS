//
//  GKHistoryController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKHistoryController: NSObject {

    static let sharedController = GKHistoryController()
    
    var availableHistoryDates = [String]()
    
    var selectedDate: String?
    
    var latestDate: String? {
        return self.availableHistoryDates.first
    }
    
    class func getURLForGankOfDate(date: String) -> NSURL? {
        let comp = date.characters.split { $0 == "-" }
        guard comp.count == 3 else { return nil }
        let URLString = "http://gank.io/api/day/\(String(comp[0]))/\(String(comp[1]))/\(String(comp[2]))"
        return NSURL(string: URLString)
    }
    
}
