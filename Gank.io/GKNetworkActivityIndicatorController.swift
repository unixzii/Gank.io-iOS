//
//  GKNetworkActivityIndicatorController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class SimpleTimer {
    
    private var _cancelled = false
    
    init(interval: NSTimeInterval, handler: Void -> Void) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_MSEC)))
        dispatch_after(time, dispatch_get_main_queue()) { [weak self] in
            if self?._cancelled == false {
                handler()
            }
        }
    }
    
    func cancel() {
        self._cancelled = true
    }
    
}

class GKNetworkActivityIndicatorController: NSObject {
    
    static let sharedController = GKNetworkActivityIndicatorController()

    private var _retainCount = 0
    private var _timer: SimpleTimer?
    
    func startActivity() {
        self._retainCount += 1
        
        self.showIndicator()
    }
    
    func endActivity() {
        self._retainCount -= 1
        
        if self._retainCount <= 0 {
            self._retainCount = 0
            
            self._timer = SimpleTimer(interval: 1000) {
                self.hideIndicator()
            }
        }
    }
    
    func showIndicator() {
        self._timer?.cancel()
        self._timer = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func hideIndicator() {
        self._timer?.cancel()
        self._timer = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}
