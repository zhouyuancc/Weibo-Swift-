//
//  BaseTableViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/22.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
/**
 通知 : 层级结构较深
 代理 : 父子,方法较多时使用
 block : 父子,方法较少时使用(一般1个方法)
 */
class BaseTableViewController: UITableViewController {
    
    //访客视图
    var visitorView: VisitorView?
    var isLogin = false
    
    override func loadView() {
        
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 访客界面
    private func setupVisitorView()
    {
        //1.创建访客视图
        visitorView = VisitorView.visitorView()
//        otherView.backgroundColor = UIColor(white: 232.0/255.0, alpha: 1.0)
        view = visitorView
        
        //2.设置代理
//        visitorView?.delegate = self;
        
        //用代理大材小用,可以直接监听按钮点击事件
        visitorView?.registerButton.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        visitorView?.loginButton.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //3.添加导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"注册",style: UIBarButtonItemStyle.Plain,target: self,action: #selector(BaseTableViewController.registerBtnClick(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"登录",style: UIBarButtonItemStyle.Plain,target: self,action: #selector(BaseTableViewController.loginBtnClick(_:)))
       
    }
    
    //监听注册按钮点击
    @objc private func registerBtnClick(btn: UIButton)
    {
        
    }
    
    //监听登录按钮点击
    @objc private func loginBtnClick(btn: UIButton)
    {
        //1.创建登录界面
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        
        //2.弹出登陆界面
        presentViewController(vc, animated: true, completion: nil)
    }


}

//extension BaseTableViewController: VisitorViewDelegate
//{
//    func visitorViewDidClickLoginBtn(visitor:VisitorView)
//    {
//        
//    }
//    func visitorViewDidClickRegisterBtn(visitor:VisitorView)
//    {
//        
//    }
//}
