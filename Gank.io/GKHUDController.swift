//
//  GKHUDController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKHUDAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var forDismissal: Bool
    
    init(forDismissal: Bool) {
        self.forDismissal = forDismissal
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.viewForKey(self.forDismissal ? UITransitionContextFromViewKey : UITransitionContextToViewKey) else { return }
        
        if !self.forDismissal {
            transitionContext.containerView()?.addSubview(view)
        }
        
        view.alpha = self.forDismissal ? 1 : 0
        
        UIView.animateWithDuration(0.2, animations: {
            view.alpha = self.forDismissal ? 0 : 1
            }) {
                if self.forDismissal {
                    view.removeFromSuperview()
                }
                
                transitionContext.completeTransition($0)
        }
    }
    
}

class GKHUDController: UIViewController, UIViewControllerTransitioningDelegate {
    
    enum GKHUDStyle {
        case InProgress
        case Complete
    }
    
    private var backgroundView: UIView?
    private var styleView: UIView?
    private var titleView: UILabel?
    
    private var titleText: String
    private var style: GKHUDStyle
    
    init(title: String, style: GKHUDStyle) {
        self.titleText = title
        self.style = style
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        self.backgroundView?.frame = CGRect(x: (self.view.bounds.width - 172) / 2.0, y: (self.view.bounds.height - 120) / 2.0, width: 172, height: 120)
        self.backgroundView?.layer.cornerRadius = 5.0
        self.backgroundView?.layer.masksToBounds = true
        self.view.addSubview(self.backgroundView!)
        
        switch self.style {
        case .InProgress:
            self.styleView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            self.styleView?.frame = CGRect(x: (self.view.bounds.width - 37) / 2.0, y: (self.view.bounds.height - 37) / 2.0 - 15, width: 37, height: 37)
            (self.styleView! as! UIActivityIndicatorView).startAnimating()
            break
        case .Complete:
            break
        }
        self.view.addSubview(self.styleView!)
        
        self.titleView = UILabel()
        self.titleView?.frame = CGRect(x: (self.view.bounds.width - 152) / 2.0, y: (self.view.bounds.height - 30) / 2.0 + 30, width: 152, height: 30)
        self.titleView?.textColor = UIColor.whiteColor()
        self.titleView?.textAlignment = .Center
        self.titleView?.text = self.titleText
        self.view.addSubview(self.titleView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GKHUDAnimationController(forDismissal: false)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GKHUDAnimationController(forDismissal: true)
    }
    
}
