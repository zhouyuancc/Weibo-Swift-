//
//  AppDelegate.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/7.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import QorumLogs

@UIApplicationMain

/**
 command + shift + j 快速定位到左侧目录
 */

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        QorumLogs.enabled = true
//        QorumOnlineLogs.enabled = true
//        QorumLogs.test()
        
//        //1.创建window
//        window = UIWindow(frame:UIScreen.mainScreen().bounds)
//        window?.backgroundColor = UIColor.whiteColor()
//        
//        //2.设置根控制器
//        window?.rootViewController = MainViewController()
//        
//        //3.显示window
//        window?.makeKeyAndVisible()
        
        //设置所有导航栏UIBarButtonItem的颜色
        //一般情况下,设置全局性的属性,最好放在AppDelegate中设置,这样可以保证后续所有的操作都是设置之后的操作
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        return true
    }

}

/**
 打印
 ZYLog("打印内容",fileName: "文件名",methodName: "方法名")
 ZYLog("打印内容")
 */
func ZYLog<T>(message: T,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line) {

    #if DEBUG
//        print("\((fileName as NSString).pathComponents.last!).\(methodName)[\(lineNumber)]:\(message)")
        
        print("\(methodName)[\(lineNumber)]:\(message)")
  
    #endif
}



