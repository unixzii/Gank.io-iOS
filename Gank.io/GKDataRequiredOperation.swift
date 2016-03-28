//
//  GKDataRequiredOperation.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

protocol GKDataRequiredOperation {
    
    func getDependencyData() -> NSData?
    
}

extension GKDataRequiredOperation where Self : GKBaseOperation {
    
    func getDependencyData() -> NSData? {
        for dep in self.dependencies {
            if let URLFetchOperation = dep as? GKURLFetchOperation {
                return URLFetchOperation.data
            }
        }
        
        return nil
    }
    
}