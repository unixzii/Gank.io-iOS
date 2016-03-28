//
//  GKParseOperation.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKGankParseOperation: GKBaseOperation, GKDataRequiredOperation {
    
    private weak var _gankController: GKGankController?
    
    init(gankController: GKGankController) {
        self._gankController = gankController
    }
    
    override func main() {
        guard let data = self.getDependencyData() else { self.cancel(); return; }
        
        guard let JSONObject = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String:AnyObject] else { self.cancel(); return; }
        
        guard let results = JSONObject["results"] as? [String:[AnyObject]] else { self.cancel(); return; }
        
        let pageModel = GKGankPageModel()
        
        for (category, entities) in results {
            let categoryModel = GKGankCategoryModel()
            categoryModel.title = category
            
            for entity in entities {
                if let _entity = entity as? [String:AnyObject] {
                    let entityModel = GKGankEntityModel()
                    entityModel.title = _entity["desc"] as? String
                    entityModel.gankID = _entity["_id"] as? String
                    entityModel.URL = NSURL(string: _entity["url"] as? String ?? "")
                    entityModel.who = _entity["who"] as? String
                    
                    categoryModel.entities?.addObject(entityModel)
                }
            }
            
            if categoryModel.title == "福利" {
                pageModel.fuliEntity = categoryModel.entities?.firstObject as? GKGankEntityModel
            } else {
                pageModel.categories?.addObject(categoryModel)
            }
        }
        
        self._gankController?.pageModel = pageModel
        
        self.observer?.operationWillFinish()
        self.complete()
    }
    
}
