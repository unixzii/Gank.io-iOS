//
//  GKMeizhiCollectionViewCell.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GKMeizhiCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var _imageURL: NSURL!
    
    private let queue = NSOperationQueue()
    
    var imageURL: NSURL {
        set(newURL) {
            self._imageURL = newURL
            self.loadImage()
        }
        
        get {
            return self._imageURL
        }
    }
    
    weak var controller: GKMeizhiController?
    
    func loadImage() {
        queue.cancelAllOperations()
        self.imageView.image = nil
        
        if let image = self.controller?.getImageFromCacheForURL(self.imageURL) {
            self.imageView.image = image
            return
        }
        
        let imageFetchOperation = GKURLFetchOperation(URL: self.imageURL)
        let updateUIOperation = NSBlockOperation {
            if let data = imageFetchOperation.data {
                if let image = UIImage(data: data) {
                    self.controller?.putImageToCache(image, forURL: self.imageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        UIView.transitionWithView(self.imageView, duration: 0.5, options: .TransitionCurlDown, animations: {
                            self.imageView.image = image
                            }, completion: nil)
                    }
                }
            }
        }
        
        updateUIOperation.addDependency(imageFetchOperation)
        
        self.queue.addOperation(imageFetchOperation)
        self.queue.addOperation(updateUIOperation)
    }
    
}
