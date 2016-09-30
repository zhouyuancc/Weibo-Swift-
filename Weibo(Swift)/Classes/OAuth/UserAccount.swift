//
//  UserAccount.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/8/15.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {

    //令牌
    var access_token: String?
    
    //从授权那一刻开始,多少秒之后过期的时间
    //注意: 基本数据类型的可选类型 在super.init()方法中不会分配存储空间
    var expires_in: NSInteger = 0//如果属性是基本数据类型,那么建议不要使用可选类型
    {
        didSet{
            //生成正在过期时间
            //int转NSDate
            expires_Date = NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    
    //真正过期时间
    var expires_Date: NSDate?
    
    //用户ID
    var uid: String?
    
    //用户头像地址(大图),180×180像素
    var avatar_large: String?
    
    //用户昵称
    var screen_name: String?
    
    // MARK: - 生命周期方法
    init(dict: [String: AnyObject]) {
        
        ZYLog(dict)
        
        super.init()
        //初始化方法中,使用KVC,必须先调用super.init()初始化对象
        //基本数据类型的可选类型 在super.init()方法中不会分配存储空间
        self.setValuesForKeysWithDictionary(dict)
    }
    
    //当KVC发现没有对应的key时会调用
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String
    {
        //模型 转 字典
        let property = ["access_token","expires_in","uid"]
        let dict = dictionaryWithValuesForKeys(property)
        //字典 转 字符串
        return "\(dict)"
    }
    
    // MARK: - 外部控制方法
    // 归档模型
    func saveAccount() -> Bool
    {
        /*
        //获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        //生成缓存路径
        let filePath = (path as NSString).stringByAppendingPathComponent("useraccount.plist")
        ZYLog(filePath)
        */
        
        //归档对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    //定义属性保存授权模型
    static var account: UserAccount?
    
    /**
     string也能.出来
     */
    static let filePath: String = "useraccount.plist".cachesDir()
    
    //解归档模型
    class func loadUserAccount() -> UserAccount?
    {
        //1.判断是否已经加载过了
        if UserAccount.account != nil {
            ZYLog("已经有加载过")
            //直接返回
            return UserAccount.account
        }
        ZYLog(UserAccount.filePath)
        
        //2.尝试从文件中加载
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.filePath) as? UserAccount else{
            return nil
        }
        
        //2015 2016
        //比较 过期时间与当前时间
        guard let date = account.expires_Date where date.compare(NSDate()) != NSComparisonResult.OrderedAscending else{
            
            ZYLog("过期了")
            return nil
        }
        
        UserAccount.account = account
        
        return UserAccount.account
    }
    
    //获取用户信息
    func loadUserInfo(finished: (account: UserAccount?,error:NSError?) -> ()) {
        
        //断言
        //断定access_token一定是不等于nil的,如果运行时access_token==nil,那么程序就会崩溃,并报错
        assert(access_token != nil, "使用该方法必须先授权")
        
        //1.准备请求路径
        let path = "2/users/show.json"
        //2.准备请求参数
        let parameters = ["access_token": access_token!,"uid": uid!]
        //3.发送GET请求
        NetworkTools.shareInstance.GET(path, parameters: parameters, success: { (task, objc) in
            
                let dict = objc as! [String: AnyObject]
                
                //1.取出用户信息
                self.avatar_large = dict["avatar_large"] as? String
                self.screen_name = dict["screen_name"] as? String
                
                //2.保存授权信息
                finished(account: self, error: nil)
            
            }) { (task, error) in
                
                ZYLog(error)
                finished(account: nil, error: error)
        }
        
    }
    
    //判断用户是否登录
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as NSInteger
        self.uid = aDecoder.decodeObjectForKey("uid") as? String
        self.expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
    
}
