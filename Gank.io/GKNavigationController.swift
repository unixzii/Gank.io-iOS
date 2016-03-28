//
//  GKNavigationController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKNavigationController: UINavigationController {
    
    private var backgroundImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let originalRecognizer = self.interactivePopGestureRecognizer
        let modRecognizer = UIPanGestureRecognizer(target: (originalRecognizer?.delegate)!, action: Selector("handleNavigationTransition:"))
        modRecognizer.delegate = self
        
        self.view.removeGestureRecognizer(originalRecognizer!)
        self.view.addGestureRecognizer(modRecognizer)
        
        self.backgroundImageView = UIImageView(image: UIImage(named: "bg"))
        self.backgroundImageView?.frame = self.view.bounds
        self.view.insertSubview(self.backgroundImageView!, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension GKNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count <= 1 {
            return false
        }
        
        return true
    }
    
}