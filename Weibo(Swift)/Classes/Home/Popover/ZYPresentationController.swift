//
//  ZYPresentationController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/26.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class ZYPresentationController: UIPresentationController {
    
    /**
     一.如果{0}转场modal出来的控制器{1}移除原有的控制器
     1.1 不自定义,会
     1.2 自定义,不会
     二.如果{0}转场modal出来的控制器{1}
     2.1 不自定义,尺寸和屏幕一样
     2.2 自定义,尺寸可以在containerViewWillLayoutSubviews方法中控制
     三.containerView   非常重要,容器视图,所有modal出来的视图都是添加到containerView上的
     四.presentedView() 非常重要,通过该方法能够拿到弹出的视图
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    //用于布局转场动画弹出的控件
    override func containerViewWillLayoutSubviews() {
        //设置弹出视图的尺寸
        presentedView()?.frame = CGRect(x: 100, y: 52, width: 200, height: 200)
        
        //添加蒙版
        containerView?.insertSubview(coverButton, atIndex: 0)
        coverButton.addTarget(self, action: #selector(ZYPresentationController.coverBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    // MARK: - 内部控制方法
    @objc private func coverBtnClick()
    {
//        ZYLog(presentedViewController)
//        ZYLog(presentingViewController)
        //让菜单消失
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var coverButton: UIButton = {
       let btn = UIButton()
        btn.frame = UIScreen.mainScreen().bounds
        btn.backgroundColor = UIColor.clearColor()
        return btn
    }()
    
}
