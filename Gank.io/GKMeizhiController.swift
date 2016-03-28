//
//  GKMeizhiController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

typealias ImageTapHandler = UIImage -> Void

class GKMeizhiController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    private var _caches = [String:UIImage]()
    
    var meizhiURLs = [NSURL]()
    var itemTapHandler: ImageTapHandler?
    var numberOfInsertedItems = 0
    
    func putImageToCache(image: UIImage, forURL URL: NSURL) {
        self._caches[URL.absoluteString] = image
    }
    
    func getImageFromCacheForURL(URL: NSURL) -> UIImage? {
        return self._caches[URL.absoluteString]
    }
    
    func clearCache() {
        self._caches.removeAll()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfInsertedItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? GKMeizhiCollectionViewCell
        
        cell?.imageURL = self.meizhiURLs[indexPath.row]
        cell?.controller = self
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let URL = self.meizhiURLs[indexPath.row]
        if let image = self.getImageFromCacheForURL(URL) {
            if self.itemTapHandler != nil {
                self.itemTapHandler!(image)
            }
        }
    }
    
}
