//
//  MainViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/14.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    //override 重写父类的方法
    override func viewDidLoad() {
        super.viewDidLoad()

        //直接设置图片属性Render As为Original Image
        //iOS7以后只需设置tintColor,那么图片和文字都会按照tintColor渲染
        tabBar.tintColor = UIColor.orangeColor()
        
        //添加子控制器
        addChildViewControllers()
        
//        nameSpaceByIf()
        
    }

    func addChildViewControllers()
    {
        //读取json数据
        guard let filePath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else{
            ZYLog("json文件不存在")
            return
        }
        
        guard let data = NSData(contentsOfFile: filePath)
            else{
                ZYLog("加载二进制数据失败")
                return
        }
        
        do{
            //1.但凡 带throws的方法,那么必须进行try处理
            //2.而只要看到try , 就需要写上 do catch
            //3.do{}catch{} , 只有do中的代码发生了错误,才会执行catch{}中的代码
            //4.try 正常处理异常,也就是通过do catch来处理(推荐)
            //  try! 告诉系统一定不会有异常,可以不通过do catch来处理(开发中不推荐这样写,一旦发生异常程序就会崩溃;无错:返回一个确定的值)
            //  try? 告诉系统可能有错也可能没错,如果有错:返回nil,可以不通过do catch来处理;无错:返回可选类型
            let objc = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [[String:AnyObject]]
            //[[String:AnyObject]]数组字典
//            public class func JSONObjectWithData(data: NSData, options opt: NSJSONReadingOptions) throws -> AnyObject
            
            
            for dict in objc
            {
                ZYLog(dict)//["title": 首页123, "vcName": HomeTableViewController, "imageName": tabbar_home]
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                
                addChildViewControllerWithStr(vcName, title: title, imageName: imageName)

            }
            
            ZYLog(objc)
            
        }catch{
            //只要try对应的方法发生了异常,就会执行catch{}中的代码
            
            addChildViewControllerWithStr("HomeTableViewController", title: "首页", imageName: "tabbar_home")
            addChildViewControllerWithStr("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewControllerWithStr("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewControllerWithStr("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        }
        
        
//        let str = String(contentsOfFile: filePath,encoding: NSUTF8StringEncoding)
//        ZYLog(str)
    }
    
    //Swift支持方法的重载,即:只要
    //方法的参数个数 或 数据类型不同
    //,系统就会认为是2个方法
    /**
     添加1个子控制器
     */
    func addChildViewControllerWithStr(vcName: String?, title:String?, imageName: String?)
    {
        //动态获取命名空间
        //由于字典\数组中只能存储对象,所以取出来是一个AnyObject;若key没有对应值,就取不到值AnyObject?
        guard let name =  NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else{
            
            ZYLog("获取命名空间失败!")
            return;
        }
        
        //name有值
        //nameSpace命名空间
        ZYLog(name)//如果name有()符号,获取不到class
        
        //string -> class
        var cls:AnyClass? = nil
        if let childControllerName = vcName
        {
            cls = NSClassFromString(name + "." + childControllerName)
        }
        ZYLog(cls)
        
        //告诉系统这个Class的确切类型
        guard let typeCls = cls as? UITableViewController.Type else
        {
            ZYLog("cls不能当做UITableViewController")
            return;
        }
        
        //typeCls有值才能进这里
        
        //通过Class创建对象
        let childController = typeCls.init()
        
        ZYLog(childController)
        
        childController.title = title
        if let ivName = imageName
        {
            childController.tabBarItem.image = UIImage(named: ivName)
            childController.tabBarItem.selectedImage = UIImage(named: ivName + "_highlighted")
        }
        
        let nav = UINavigationController(rootViewController:childController)
        addChildViewController(nav)
    }
    /**
     guard解决if太多形成的嵌套问题
     */
    //        guard 条件表达式 else {
    //
    //            //条件为false才会执行
    //            return;
    //        }
    func nameSpaceByGuard() {

        //动态获取命名空间
        //由于字典\数组中只能存储对象,所以取出来是一个AnyObject;若key没有对应值,就取不到值AnyObject?
        guard let name =  NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else{
            
            ZYLog("获取命名空间失败!")
            return;
        }
        
        //name有值
        //nameSpace命名空间
        ZYLog(name)//如果name有()符号,获取不到class
        
        //string -> class
        let cls: AnyClass? = NSClassFromString(name + "." + "HomeTableViewController")
        
        ZYLog(cls)
        
        //告诉系统这个Class的确切类型
        guard let typeCls = cls as? UITableViewController.Type else
        {
            ZYLog("cls不能当做UITableViewController")
            return;
        }
        
        //typeCls有值才能进这里
            
        //通过Class创建对象
        let childController = typeCls.init()

        ZYLog(childController)
    }
    
    /**
     用字符串创建类,需要加命名空间
     string -> class
     */
    func nameSpaceByIf(){
        
        //动态获取命名空间
        //由于字典\数组中只能存储对象,所以取出来是一个AnyObject;若key没有对应值,就取不到值AnyObject?
        if let name =  NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String//as? 前面可能没有值
        {//name有值
            //nameSpace命名空间
            ZYLog(name)//如果name有()符号,获取不到class
            
            //string -> class
            let cls: AnyClass? = NSClassFromString(name + "." + "HomeTableViewController")
            
            ZYLog(cls)
            
            //告诉系统这个Class的确切类型
            if let typeCls = cls as? UITableViewController.Type
            {//typeCls有值才能进这里
                
                //通过Class创建对象
//                let childController = typeCls.init()
//                
//                ZYLog(childController)
            }
            
        }
    }

    /**
     添加子控制器
     */
    func addChildViewControllersBackup()
    {
        addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    //Swift支持方法的重载,即:只要
    //方法的参数个数 或 数据类型不同
    //,系统就会认为是2个方法
    /**
     添加1个子控制器
     */
    func addChildViewController(childController: UIViewController, title:String, imageName: String)
    {
        //设置子控制器的相关属性
//        childController.navigationItem.title = title//导航栏标题
//        childController.tabBarItem.title = title
        //该方法会由内向外设置标题,会调用上面2个方法
        childController.title = title//替代上面2句
        
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //包装1个导航控制器
        let nav = UINavigationController(rootViewController:childController)
        //将自控制器添加到UITabBarController中
        addChildViewController(nav)
    }
    
    /**
     备份
     */
    func backup() {
        
        //1.添加子控制器
        //1.1创建子控制器
        //注意:Swift定义变量时,先用let(常量),需要修改时用var
        let vc = HomeTableViewController()
        //1.2设置子控制器的相关属性
        vc.tabBarItem.title = "首页"
        vc.tabBarItem.image = UIImage(named: "tabbar_home")
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")
        //直接设置图片属性Render As为Original Image
        
        //iOS7以后只需设置tintColor,那么图片和文字都会按照tintColor渲染
        tabBar.tintColor = UIColor.orangeColor()
        
        //1.3将自控制器添加到UITabBarController中
        addChildViewController(vc)
    }

}
