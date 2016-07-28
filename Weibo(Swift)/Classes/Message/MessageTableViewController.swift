//
//  MessageTableViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/14.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.判断用户是否登录
        if !isLogin {//没登录
            //设置访客视图
            visitorView?.setupVisitorInfo("visitordiscover_image_message", title: "登陆后,别人评论你的微博,发给你的信息,都会在这里收到")
            return
        }
        
    }
    


}
