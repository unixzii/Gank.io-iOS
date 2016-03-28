//
//  GKHistoryParseOperation.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKHistoryParseOperation: GKBaseOperation, GKDataRequiredOperation {

    override func main() {
        guard let data = self.getDependencyData() else { self.cancel(); return; }
        
        guard let JSONObject = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String:AnyObject] else { self.cancel(); return; }
        
        guard let results = JSONObject["results"] as? [String] else { self.cancel(); return; }
        
        GKHistoryController.sharedController.availableHistoryDates = results
        
        self.observer?.operationWillFinish()
        complete()
    }
    
}
