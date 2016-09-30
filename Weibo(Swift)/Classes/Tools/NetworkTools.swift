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
    
}
