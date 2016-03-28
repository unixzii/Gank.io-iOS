//
//  ViewController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/26.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit

class GanhuoViewController: UIViewController, UIViewControllerPreviewingDelegate, GKReloadable {
    
    private var context = 0
    
    private var tableView: UITableView!
    private var imageView: UIImageView!
    
    private let queue = NSOperationQueue()
    
    private var firstAppear = true
    
    private var gankController = GKGankController()
    
    private var currentHUD: GKHUDController?
    private var historyViewController: HistoryViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        let historyBarItem = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(GanhuoViewController.historyItemDidTap))
        self.navigationItem.rightBarButtonItem = historyBarItem
        
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.contentInset = UIEdgeInsets(top: 320, left: 0, bottom: 100, right: 0)
        self.tableView.delegate = self.gankController
        self.tableView.dataSource = self.gankController
        self.tableView.registerNib(UINib(nibName: "GKGankTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        self.tableView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: &self.context)
        
        self.registerForPreviewingWithDelegate(self, sourceView: self.tableView)
        
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300))
        self.imageView.userInteractionEnabled = true
        self.imageView.contentMode = .Center
        self.imageView.clipsToBounds = true
        self.view.addSubview(self.imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GanhuoViewController.imageViewDidTap))
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        self.gankController.itemTapHandler = {
            self.handleItemSelection($0)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if self.currentHUD != nil {
            self.currentHUD?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.firstAppear {
            self.gankController.pageModel = nil
            
            self.imageView.image = nil
            self.tableView.reloadData()
            
            self.reloadData()
            self.firstAppear = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object as? UITableView == self.tableView {
            self.adjustImageView()
        }
    }

    // MARK: - UIViewControllerPreviewingDelegate
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location) else {
            return nil
        }
        
        previewingContext.sourceRect = (self.tableView.cellForRowAtIndexPath(indexPath)?.frame)!
        
        let URL = self.gankController.gankEntityAtIndexPath(indexPath).URL!
        
        let safariVC = WebViewController(URL: URL, entersReaderIfAvailable: true)
        safariVC.URL = URL
        
        return safariVC
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.presentViewController(viewControllerToCommit, animated: true, completion: nil)
    }
    
    // MARK: - GKReloadable
    
    func reloadData() {
        let HUD = GKHUDController(title: "正在加载...", style: .InProgress)
        self.presentViewController(HUD, animated: true, completion: nil)
        
        self.currentHUD = HUD
        
        let historyFetchOperation = GKURLFetchOperation(URL: NSURL(string: "http://gank.io/api/day/history")!)
        let historyParseOperation = GKHistoryParseOperation()
        let beginFetchGankOperation = NSBlockOperation {
            if GKHistoryController.sharedController.selectedDate == nil {
                GKHistoryController.sharedController.selectedDate = GKHistoryController.sharedController.latestDate
            }
            
            guard let selectedDate = GKHistoryController.sharedController.selectedDate else { self.failedToReloadData(); return }
            guard let URL = GKHistoryController.getURLForGankOfDate(selectedDate) else { self.failedToReloadData(); return }
            
            let gankFetchOperation = GKURLFetchOperation(URL: URL)
            let gankParseOperation = GKGankParseOperation(gankController: self.gankController)
            let updateUIOperation = NSBlockOperation {
                dispatch_async(dispatch_get_main_queue()) {
                    if UIApplication.sharedApplication().applicationState == .Active {
                        HUD.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    self.tableView.reloadData()
                }
                
                if let fuliEntity = self.gankController.pageModel?.fuliEntity {
                    let fuliFetchOperation = GKURLFetchOperation(URL: fuliEntity.URL!)
                    let updateFuliImageViewOperation = NSBlockOperation {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.imageView.image = UIImage(data: fuliFetchOperation.data!)
                        }
                    }
                    
                    updateFuliImageViewOperation.addDependency(fuliFetchOperation)
                    
                    self.queue.addOperation(fuliFetchOperation)
                    self.queue.addOperation(updateFuliImageViewOperation)
                }
            }
            
            gankParseOperation.addDependency(gankFetchOperation)
            updateUIOperation.addDependency(gankParseOperation)
            
            self.queue.addOperation(gankFetchOperation)
            self.queue.addOperation(gankParseOperation)
            self.queue.addOperation(updateUIOperation)
        }
        
        historyParseOperation.addDependency(historyFetchOperation)
        beginFetchGankOperation.addDependency(historyParseOperation)
        
        self.queue.addOperation(historyFetchOperation)
        self.queue.addOperation(historyParseOperation)
        self.queue.addOperation(beginFetchGankOperation)
    }
    
    // MARK: -
    
    func failedToReloadData() {
        
    }
    
    func adjustImageView() {
        let offsetY = self.tableView.contentOffset.y
        let translateY = -offsetY - 300
        
        if translateY > 0 {
            self.imageView.frame.size.height = 300 + translateY
        } else {
            self.imageView.frame.size.height = max(300 + translateY, 0)
        }
    }
    
    func handleItemSelection(entity: GKGankEntityModel) {
        /*
        let webViewController = WebViewController()
        webViewController.URL = entity.URL
        
        self.navigationController?.pushViewController(webViewController, animated: true)
         */
        
        let safariVC = WebViewController(URL: entity.URL!, entersReaderIfAvailable: true)
        self.presentViewController(safariVC, animated: true, completion: nil)
    }

    func historyItemDidTap() {
        self.historyViewController = HistoryViewController()
        self.historyViewController?.delegate = self
        
        self.presentViewController(UINavigationController(rootViewController: self.historyViewController!), animated: true, completion: nil)
    }
    
    func imageViewDidTap() {
        if self.imageView.image == nil {
            return
        }
        
        let fullscreenImageVC = FullscreenImageViewController()
        fullscreenImageVC.sourceRect = self.imageView.convertRect(self.imageView.frame, toView: UIApplication.sharedApplication().keyWindow)
        fullscreenImageVC.image = self.imageView.image
        
        self.presentViewController(fullscreenImageVC, animated: true, completion: nil)
    }
    
}

extension GanhuoViewController : HistoryViewControllerDelegate {
    
    func historyDidSubmit(history: String?) {
        if history != nil {
            GKHistoryController.sharedController.selectedDate = history!
            self.firstAppear = true
        }
        
        self.historyViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.historyViewController = nil
    }
    
}

