//
//  FullscreenImageViewController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/28.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class MagicMoveAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var sourceRect: CGRect!
    var forDismissal: Bool
    
    init(sourceRect: CGRect, forDismissal: Bool) {
        self.sourceRect = sourceRect
        self.forDismissal = forDismissal
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.forDismissal ? 0.4 : 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.viewForKey(self.forDismissal ? UITransitionContextFromViewKey : UITransitionContextToViewKey) else { return }
        
        if !self.forDismissal {
            transitionContext.containerView()?.addSubview(view)
            view.subviews.first?.frame = self.sourceRect
        }
        
        UIView.animateWithDuration(self.forDismissal ? 0.4 : 0.6, delay: 0, usingSpringWithDamping: self.forDismissal ? 1.2 : 0.6, initialSpringVelocity: 0.7, options: .CurveEaseOut, animations: {
            view.subviews.first?.frame = self.forDismissal ? self.sourceRect : UIScreen.mainScreen().bounds
        }) { (complete: Bool) in
            if self.forDismissal {
                view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(complete)
        }
    }
    
}

class FullscreenImageViewController: UIViewController, UIViewControllerTransitioningDelegate {

    private var imageView: UIImageView!
    
    var sourceRect: CGRect?
    var image: UIImage?
    
    init() {
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
        self.view.backgroundColor = UIColor.clearColor()
        
        if self.sourceRect == nil {
            let maskView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
            maskView.frame = self.view.bounds
            self.view.addSubview(maskView)
        }
        
        self.imageView = UIImageView(image: self.image)
        self.imageView.frame = self.view.bounds
        self.imageView.contentMode = self.sourceRect == nil ? .ScaleAspectFit : .Center
        self.imageView.clipsToBounds = true
        self.view.addSubview(self.imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FullscreenImageViewController.viewDidTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(animated: Bool) {
        if self.sourceRect != nil {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.sourceRect != nil {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.sourceRect != nil {
            return MagicMoveAnimationController(sourceRect: self.sourceRect!, forDismissal: true)
        }
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.sourceRect != nil {
            return MagicMoveAnimationController(sourceRect: self.sourceRect!, forDismissal: false)
        }
        
        return nil
    }
    
    func viewDidTap() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
