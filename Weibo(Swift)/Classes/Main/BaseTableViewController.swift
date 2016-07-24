//
//  BaseTableViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/22.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    //访客视图
    var visitorView: VisitorView?
    var isLogin = false
    
    override func loadView() {
        
        setupVisitorView()
    }
    
    // MARK: - 访客界面
    private func setupVisitorView()
    {
        visitorView = VisitorView.visitorView()
//        otherView.backgroundColor = UIColor(white: 232.0/255.0, alpha: 1.0)
        view = visitorView
    }


}
