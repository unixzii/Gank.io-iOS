//
//  GKMeizhiParseOperation.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKMeizhiParseOperation: GKBaseOperation, GKDataRequiredOperation {

    private weak var _meizhiController: GKMeizhiController?
    
    init(meizhiController: GKMeizhiController) {
        self._meizhiController = meizhiController
    }
    
    override func main() {
        guard let data = self.getDependencyData() else { self.cancel(); return; }
        
        guard let JSONObject = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String:AnyObject] else { self.cancel(); return; }
        
        guard let results = JSONObject["results"] as? [String:[AnyObject]] else { self.cancel(); return; }
        
        for (category, entities) in results {
            if category != "福利" {
                continue
            }
            
            for entity in entities {
                if let _entity = entity as? [String:AnyObject] {
                    if let URL = _entity["url"] as? String {
                        self._meizhiController?.meizhiURLs.append(NSURL(string: URL)!)
                    }
                }
            }
        }
        
        self.observer?.operationWillFinish()
        self.complete()
    }
    
}
