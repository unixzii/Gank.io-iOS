//
//  GKURLFetchOperation.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKURLFetchOperation: GKBaseOperation {

    private var _URL: NSURL?
    private var _data: NSData?
    private var _task: NSURLSessionTask?
    
    var URL: NSURL? {
        set(newURL) {
            assert(self.executing == false && self.finished == false, "Cannot set URL while executing")
            self._URL = newURL
        }
        
        get {
            return self._URL
        }
    }
    
    var data: NSData? {
        return self._data
    }
    
    override init() {
        super.init()
    }
    
    init(URL: NSURL) {
        self._URL = URL
    }
    
    override func main() {
        assert(self._URL != nil, "Must set a URL to download")
        
        let semaphore = dispatch_semaphore_create(0)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(self._URL!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            self._data = data
            
            dispatch_semaphore_signal(semaphore)
            GKNetworkActivityIndicatorController.sharedController.endActivity()
        }
        
        GKNetworkActivityIndicatorController.sharedController.startActivity()
        task.resume()
        
        self._task = task
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        self.observer?.operationWillFinish()
        self.complete()
    }
    
    override func cancel() {
        self._task?.cancel()
        GKNetworkActivityIndicatorController.sharedController.endActivity()
        
        super.cancel()
    }
    
}
