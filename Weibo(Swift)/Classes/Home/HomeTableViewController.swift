//
//  HomeTableViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/14.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.判断用户是否登录
        if !isLogin {//没登录
            //设置访客视图
            visitorView?.setupVisitorInfo(nil, title: "关注一些人,回这里看看有什么惊喜")
            return
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ZYLog("")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ZYLog("")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ZYLog("")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ZYLog("")
    }

}
