//
//  NetworkTools.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/8/15.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {
    
    //单例
    static let shareInstance: NetworkTools = {
       
        //注意: baseURL后面写上/
        let baseURL = NSURL(string: "https://api.weibo.com/")!
        
        let instance = NetworkTools(baseURL: baseURL, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        instance.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set

        
        return instance
        
    }()
    
    // MARK: - 外部控制方法
    func loadStatuses(finished: (array: [[String:AnyObject]]?, error: NSError?)->())
    {
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        //1.准备路径
        let path = "2/statuses/home_timeline.json"
        
        //2.准备参数
        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!]
        
        //3.发送GET请求
        GET(path, parameters: parameters, progress: nil, success: { (task, objc) in
            
//            ZYLog(objc)
            
            //返回数据给调用者
            //objc是个字典,把字典中statuses,转成字典数组
            guard let arr = (objc as! [String:AnyObject])["statuses"] as? [[String: AnyObject]]
                else
            {
                finished(array: nil, error: NSError(domain: "www.baidu.com", code: 1000, userInfo: ["message": "没有获取到数据"]))
                return
            }
            
            //有值
            finished(array: arr, error: nil)
            
        }) { (task, error) in
            
            //失败
            finished(array: nil, error: error)
        }
    
        
    }
    
    
}
