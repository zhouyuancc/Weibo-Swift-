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
    convenience init(imageName: String )
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        
        btn.sizeToFit()//设置frame
        //系统方法
        self.init(customView: btn)
    }
}
