//
//  GKBaseOperation.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKBaseOperation: NSOperation {

    private var _executing: Bool = false
    private var _finished: Bool = false
    
    var observer: GKOperationObserver?
    
    override var executing: Bool {
        return self._executing
    }
    
    override var finished: Bool {
        return self._finished
    }
    
    override func start() {
        var needCancel = false
        self.dependencies.forEach { (operation: NSOperation) in
            if operation.cancelled {
                needCancel = true
            }
        }
        
        if needCancel {
            self.cancel()
        }
        
        if self.cancelled {
            self.willChangeValueForKey("isFinished")
            self._finished = true
            self.didChangeValueForKey("isFinished")
            
            return
        }
        
        self.observer?.operationWillStart()
        self.willChangeValueForKey("isExecuting")
        NSThread.detachNewThreadSelector(#selector(NSOperation.main), toTarget: self, withObject: nil)
        self._executing = true
        self.didChangeValueForKey("isExecuting")
        self.observer?.operationDidStart()
    }
    
    override func cancel() {
        super.cancel()
        
        self.observer?.operationDidCancel()
    }
    
    func complete() {
        self.willChangeValueForKey("isExecuting")
        self.willChangeValueForKey("isFinished")
        
        self._executing = false
        self._finished = true
        
        self.didChangeValueForKey("isFinished")
        self.didChangeValueForKey("isExecuting")
        
        self.observer?.operationDidFinish()
    }
}
