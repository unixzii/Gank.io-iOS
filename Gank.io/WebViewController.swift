//
//  WebViewController.swift
//  Gank.io
//
//  Created by 杨弘宇 on 16/3/27.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

import UIKit
import SafariServices

class WebViewController: SFSafariViewController {
    
    var URL: NSURL!
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        let openInSafariItem = UIPreviewAction(title: "在 Safari 中打开", style: .Default) { (_: UIPreviewAction, _: UIViewController) in
            UIApplication.sharedApplication().openURL(self.URL)
        }
        return [openInSafariItem]
    }
    
}
