//
//  StatusViewModel.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/4.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

/*
 M: 模型(保存数据)
 V: 视图(展现数据)
 C: 控制器(管理模型和视图, 桥梁)
 VM:
 作用: 1.可以对M和V进行瘦身
 2.处理业务逻辑
 */
class StatusViewModel: NSObject {

    //模型对象
    var status: Status
    
    init(status: Status) {
        
        self.status = status
        
        //1.处理头像
        icon_URL = NSURL(string: status.user?.profile_image_url ?? "")
        
        //2.处理会员图标
        if (status.user?.mbrank >= -1 && status.user?.mbrank <= 6)
        {
            mbrankImage = UIImage(named: "common_icon_membership_level\(status.user?.mbrank)")
        }
        
        //3.处理认证图片
        switch status.user?.verified_type ?? -1
        {
            case 0:
                verified_image = UIImage(named: "avatar_vip")
            case 2,3,5:
                verified_image = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verified_image = UIImage(named: "avatar_grassroot")
            default:
                verified_image = nil
        }
        
//        ZYLog(status.source)
//        Optional("<a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>")
        //4.处理来源
        if let sourceStr: NSString = status.source where sourceStr != "" {
            
//            ZYLog(sourceStr)
//            <a href="http://app.weibo.com/t/feed/6vtZb0" rel="nofollow">微博 weibo.com</a>
            
            //4.1 获取从什么地方开始截取
            let startIndex = sourceStr.rangeOfString(">").location + 1 //60
            
            //4.2 获取截取多少长度
            //BackwardsSearch: 从 末尾 开始 反向 搜索 //</a>的<
            let length = sourceStr.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex //12
            
            //4.3 截取字符串
            let rest = sourceStr.substringWithRange(NSMakeRange(startIndex, length)) //微博 weibo.com
            
            source_Text = "来自: " + rest
        }
        
        //5.处理时间
//        ZYLog(status.created_at)
        // "Sun Dec 06 11:10:41 +0800 2015"
        //  EE  MM  dd HH:mm:ss Z     yyyy
        if let timeStr = status.created_at where timeStr != ""
        {
            //5.1 将服务器返回的时间格式化为 NSDate
            let createDate = NSDate.createDate(timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
            
            //5.2 生成发布微博时间对应的 字符串
            created_Time = createDate.descriptionStr()
        }
        
        //6.处理配图URL
        //6.1 从模型中取出配图数组
        if let picurls = (status.retweeted_status != nil) ? status.retweeted_status?.pic_urls : status.pic_urls
        {
            thumbnail_pic = [NSURL]()
            //注意添加大图
            bmiddle_pic = [NSURL]()
            
            //6.2 遍历配图数组下载图片
            for dict in picurls {
                
                //6.2.1 取出图片的URL字符串
                guard var urlStr = dict["thumbnail_pic"] as? String else
                {
                    continue
                }
                
                //6.2.2 根据字符串创建URL
                let url = NSURL(string: urlStr)!
                thumbnail_pic?.append(url)
                
                //6.2.3 处理大图
                urlStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
                bmiddle_pic?.append(NSURL(string: urlStr)!)
            }
        }
        
        //7.处理转发
        if let text = status.retweeted_status?.text
        {
            let name = status.retweeted_status?.user?.screen_name ?? ""
            forwardText = "@" + name + ": " + text
        }
        
        
    }
    
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?
    
    /// 用户头像URL地址
    var icon_URL: NSURL?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
    
    /// 保存所有配图URL
    var thumbnail_pic: [NSURL]?
    
    ///保存所有配图大图
    var bmiddle_pic: [NSURL]?
    
    /// 转发 
    ///转发微博格式化之后正文
    var forwardText: String?
    
}
