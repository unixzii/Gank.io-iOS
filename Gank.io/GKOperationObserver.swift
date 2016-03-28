//
//  GKOperationObserver.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

protocol GKOperationObserver {

    func operationWillStart()
    
    func operationDidStart()
    
    func operationWillFinish()
    
    func operationDidFinish()
    
    func operationDidCancel()
    
}
