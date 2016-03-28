//
//  MeizhiViewController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class MeizhiViewController: UIViewController, GKReloadable {
    
    private var collectionView: UICollectionView!

    private let queue = NSOperationQueue()
    
    private var firstAppear = true
    
    private var meizhiController = GKMeizhiController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.queue.maxConcurrentOperationCount = 5
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.bounds.width / 2.0, height: (self.view.bounds.width / 2.0) * 1.5)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.delegate = self.meizhiController
        self.collectionView.dataSource = self.meizhiController
        self.collectionView.registerNib(UINib(nibName: "GKMeizhiCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(self.collectionView)
        
        
        self.meizhiController.itemTapHandler = {
            self.imageDidTap($0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.firstAppear {
            self.reloadData()
            self.firstAppear = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        self.meizhiController.clearCache()
    }
    
    func reloadData() {
        if GKHistoryController.sharedController.availableHistoryDates.count == 0 {
            let historyFetchOperation = GKURLFetchOperation(URL: NSURL(string: "http://gank.io/api/day/history")!)
            let historyParseOperation = GKHistoryParseOperation()
            let beginFetchMeizhiOperation = NSBlockOperation {
                self.reloadData()
            }
            
            historyParseOperation.addDependency(historyFetchOperation)
            beginFetchMeizhiOperation.addDependency(historyParseOperation)
            
            self.queue.addOperation(historyFetchOperation)
            self.queue.addOperation(historyParseOperation)
            self.queue.addOperation(beginFetchMeizhiOperation)
        }
        
        self.meizhiController.meizhiURLs.removeAll()
        self.meizhiController.numberOfInsertedItems = 0
        self.collectionView.reloadData()
        
        for date in GKHistoryController.sharedController.availableHistoryDates {
            guard let URL = GKHistoryController.getURLForGankOfDate(date) else { continue }
            
            let meizhiFetchOperation = GKURLFetchOperation(URL: URL)
            let meizhiParseOperation = GKMeizhiParseOperation(meizhiController: self.meizhiController)
            let updateUIOperation = NSBlockOperation {
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.performBatchUpdates({
                        let indexPath = NSIndexPath(forRow: self.collectionView.numberOfItemsInSection(0), inSection: 0)
                        self.meizhiController.numberOfInsertedItems += 1
                        self.collectionView.insertItemsAtIndexPaths([indexPath])
                        }, completion: nil)
                }
            }
            
            meizhiParseOperation.addDependency(meizhiFetchOperation)
            updateUIOperation.addDependency(meizhiParseOperation)
            
            self.queue.addOperation(meizhiFetchOperation)
            self.queue.addOperation(meizhiParseOperation)
            self.queue.addOperation(updateUIOperation)
        }
    }
    
    func imageDidTap(image: UIImage) {
        let fullscreenImageVC = FullscreenImageViewController()
        fullscreenImageVC.image = image
        
        self.presentViewController(fullscreenImageVC, animated: true, completion: nil)
    }

}
