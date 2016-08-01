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
        
        //2.初始化导航条
        setupNav()
        
        //3.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: ZYPresentationManagerDidPresented, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: ZYPresentationManagerDidDismissed, object: animatorManager)
    }
    
    deinit
    {
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 内部控制
    /**
     添加导航条按钮
     */
    private func setupNav()
    {
        //1.添加左右按钮
        //UIBarButtonItem+Extension.swift分类
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        //2.添加标题按钮
        navigationItem.titleView = titleButton
    }
    
    @objc private func titleChange()
    {
        titleButton.selected = !titleButton.selected
    }
    
    @objc private func titleBtnClick(btn:TitleButton)
    {
        //1.修改按钮的状态
//        btn.selected = !btn.selected
        
        //2.显示菜单
        //2.1创建菜单//从新建的Popover.storyboard中创建UIViewController
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else
        {
            return;
        }
        //自定义转场动画
        menuView.transitioningDelegate = animatorManager
        //设置转场代理
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        //2.2弹出菜单
        presentViewController(menuView, animated: true, completion: nil)
    }
    
    @objc private func leftBtnClick() {
        ZYLog("")
        
    }
    @objc private func rightBtnClick() {

        //1.创建二维码控制器
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.弹出二维码控制器
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var animatorManager: ZYPresentationManager = {
        
        //: ZYPresentationManager 明确指定数据类型
       
        let manager = ZYPresentationManager()
        manager.presentFrame = CGRect(x: 100, y: 52, width: 200, height: 200)
        return manager
    }()
    
    //标题按钮
    private lazy var titleButton: TitleButton = {
        
        let btn = TitleButton()
        
        btn.setTitle("首页", forState: UIControlState.Normal)
        //        覆盖TitleButton的image Normal
        //        titleButton.setImage(UIImage(named: "navigationbar_friendattention"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()

}

