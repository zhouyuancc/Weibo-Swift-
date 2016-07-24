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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    // MARK: - 把按钮添加到tabBar中间
        tabBar.addSubview(composeButton)
        
        let rect = composeButton.frame
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width,height: rect.height)
    }
    
    // MARK: - 监听加号按钮点击
    @objc private func compseBtnClick(btn: UIButton)
    {
//        ZYLog(btn)
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
