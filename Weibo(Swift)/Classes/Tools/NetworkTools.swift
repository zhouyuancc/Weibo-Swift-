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
    func loadStatuses(since_id: String, max_id: String, finished: (array: [[String:AnyObject]]?, error: NSError?)->())
    {
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        //1.准备路径
        let path = "2/statuses/home_timeline.json"
        
        //2.准备参数
        let temp = (max_id != "0") ? "\(Int(max_id)! - 1)" : max_id
        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!,"since_id": since_id, "max_id": temp]
        
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
    
    ///发送微博的接口
    func sendStatus(statusText: String, image: UIImage?, finished: (dict: [String : AnyObject]?, error: NSError?) -> ()) {
        
        //定义路径
        var path = "/2/statuses/"
        
        //定义参数
        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!,"status": statusText]
        
        if image == nil {
            
            //1.获取发送微博的路径
            path += "update.json"
            
            //2.发送微博
            POST(path, parameters: parameters, success: { (task, objc) in
                
                    finished(dict: objc as? [String : AnyObject], error: nil)
                
                }, failure: { (task, error) in
                    
                    finished(dict: nil, error: error)
            })
            //
        }
        else{
            //1.获取发送微博的路径(带图片)
            path += "upload.json"
            
            //2.发送微博
            POST(path, parameters: parameters, constructingBodyWithBlock: { (formData) in
                
                //2.1.将UIImage对象转成NSData类型
                let imageData = UIImagePNGRepresentation(image!)!
                
                //2.2.拼接图片内容
                formData.appendPartWithFileData(imageData, name: "pic", fileName: "1.png", mimeType: "image/png")
                
                }, success: { (task, objc) in
                    
                    finished(dict: objc as? [String : AnyObject], error: nil)
                }, failure: { (task, error) in
                    
                    finished(dict: nil, error: error)
            })
            //
            
        }
    }
    
}
