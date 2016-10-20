//
//  MainStoryboardViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/22.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class MainStoryboardViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - 生命周期方法
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - 把按钮添加到tabBar中间
        //1.添加加号按钮
        tabBar.addSubview(composeButton)
        
        //2.设置加号按钮的位置
        //保存按钮尺寸
        let rect = composeButton.frame
        //计算宽度
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        //设置按钮的位置
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width,height: rect.height)
    }
    
    // MARK: - 监听加号按钮点击
    @objc private func compseBtnClick(btn: UIButton)
    {
        /**
         UITextField
         不可以换行
         不可以滚动
         可以显示占位提示文本 placeholder
         
         UITextView
         可以换行
         可以滚动
         不可以显示占位提示文本
         */
        //1.创建控制器
        let sb = UIStoryboard(name: "ComposeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        
        //2.弹出控制器
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var composeButton: UIButton = {
        () -> UIButton
        in
        //1.创建按钮
        let btn = UIButton(imageName:"tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        
        //2.监听按钮点击
        btn.addTarget(self, action: #selector(MainStoryboardViewController.compseBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
       return btn
    }()
    
    

}
