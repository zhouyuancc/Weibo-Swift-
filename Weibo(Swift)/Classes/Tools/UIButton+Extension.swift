//
//  UIButton+Extension.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/21.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

//扩充
extension UIButton
{
//    [[UIButton alloc] init];
//    UIButton()
//
//    [[UIButton alloc] initWithFrame: CGRect()];
//    UIButton(frame: CGRect())
    
    //convenience便利,方便
    /**
     如果构造方法前面,
     没有convenience: 一个初始化构造方法(指定构造方法)
     有convenience: 一个便利的构造方法
     
     指定和便利的区别
     指定构造方法: 必须对所有属性进行初始化
     便利构造方法: 不用对所有属性进行初始化,"依赖于指定构造方法"
     
     一般情况下,如果想给系统的类提供一个快速创建的方法,就自定义一个便利构造方法
     */
    convenience init(imageName:String?,backgroundImageName:String?)//便利构造方法
    {
        self.init()//必须写//指定构造方法
        
        //2.设置前景图片
        if let name = imageName {
            
            //加号图片
            setImage(UIImage(named: name), forState: UIControlState.Normal)
            setImage(UIImage(named: name + "_highlighted"), forState: UIControlState.Highlighted)
        }
        //3.设置背景图片
        if let backgroundName = backgroundImageName {
            
            //橙色背景
            setBackgroundImage(UIImage(named: backgroundName), forState: UIControlState.Normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), forState: UIControlState.Highlighted)
        }
        
        //4.调整按钮尺寸
        sizeToFit()
    }
}