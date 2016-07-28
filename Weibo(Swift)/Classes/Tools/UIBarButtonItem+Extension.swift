//
//  UIBarButtonItem+Extension.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/25.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    //1.用于快速创建一个对象
    //2.依赖于指定构造方法
    convenience init(imageName: String,target: AnyObject?, action: Selector)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        
        btn.sizeToFit()//设置frame
        
        //模仿系统监听btn点击事件
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        //系统方法
        self.init(customView: btn)
    }
}
