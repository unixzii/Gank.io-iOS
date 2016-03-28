//
//  TabViewController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    private var _totalTapTimes = 0
    private var _lastTapTime: NSTimeInterval = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "干货集中营"
        
        self.tabBar.tintColor = UIColor(red:0.49, green:0.38, blue:0.27, alpha:1)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TabViewController.tabBarDidTap))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.tabBar.addGestureRecognizer(tapGestureRecognizer)
        
        let ganhuoVC = GanhuoViewController()
        ganhuoVC.tabBarItem.title = "干货"
        ganhuoVC.tabBarItem.image = UIImage(named: "ganhuo")
        
        let meizhiVC = MeizhiViewController()
        meizhiVC.tabBarItem.title = "妹纸"
        meizhiVC.tabBarItem.image = UIImage(named: "meizhi")
        
        let moreVC = MoreViewController()
        moreVC.tabBarItem.title = "更多"
        moreVC.tabBarItem.image = UIImage(named: "more")
        
        self.setViewControllers([ganhuoVC, meizhiVC, moreVC], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarDidTap(sender: UITapGestureRecognizer?) {
        let now = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
        
        if (now - self._lastTapTime > 2) {
            self._totalTapTimes = 1
        } else {
            self._totalTapTimes += 1
        }
        
        self._lastTapTime = now
        
        if (self._totalTapTimes == 10) {
            (self.selectedViewController as? GKReloadable)?.reloadData()
            self._totalTapTimes = 0
        }
    }

}
