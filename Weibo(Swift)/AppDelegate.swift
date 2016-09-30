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
        //Main.storyboard中设置了tintColor属性,会点击变成橙色
        //其他storyboard也需要这个功能,所以写在
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        //注册监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeRootViewController(_:)), name: ZYSwitchRootViewController, object: nil)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

extension AppDelegate
{
    //切换根控制器
    func changeRootViewController(notice:NSNotification)
    {
        if notice.object as! Bool
        {
            
            let sb = UIStoryboard(name: "Main", bundle: nil)

            window?.rootViewController = sb.instantiateInitialViewController()!
        }
        else
        {
            let sb = UIStoryboard(name: "Welcome", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()!
        }
        
    }
    
    
    //用于返回默认界面
    private func defaultViewController() -> UIViewController
    {
        //1.判断是否登录
        if UserAccount.isLogin() {
            //2.判断是否有新版本
            if isNewVersion() {
            
                let sb = UIStoryboard(name: "Newfeature", bundle: nil)
                return sb.instantiateInitialViewController()!
            }
            else
            {
                let sb = UIStoryboard(name: "Welcome", bundle: nil)
                return sb.instantiateInitialViewController()!
            }
        }
        
        //没登录
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateInitialViewController()!
        
    }
    
    //判断是否有新版本
    func isNewVersion() -> Bool {
        //1.加载info.plist
        //2.获取当前软件的版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        //3.获取以前的软件版本号?可选
        let defaults = NSUserDefaults.standardUserDefaults()
        let sanboxVersion = (defaults.objectForKey("version") as? String) ?? "0.0"
        
        //4.用当前的版本号和以前的版本号进行比较
        //1.0 0.0
        if currentVersion.compare(sanboxVersion) == NSComparisonResult.OrderedDescending
        {
            //如果 当前>以前,有新版本
            ZYLog("有新版本")
            
            defaults.setObject(currentVersion, forKey: "version")
            defaults.synchronize() // < iOS7写,iOS7后不用写
            return true
        }
        ZYLog("没有新版本")
        return false
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



