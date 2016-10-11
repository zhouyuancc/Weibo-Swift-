//
//  StatusListModel.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/9.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SDWebImage

class StatusListModel: UIView {
    
    /// 保存所有微博数据
    var statuses: [StatusViewModel]?
    
    /// 获取微博数据
    func loadData(lastStatus: Bool, finished: (models:[StatusViewModel]?, error: NSError?)->())
    {
        //1.准备since_id和max_id
        var since_id = statuses?.first?.status.idstr ?? "0"
        var max_id = "0"
        if lastStatus
        {
            since_id = "0"
            max_id = statuses?.last?.status.idstr ?? "0"
        }
        
        //2.发送网络请求获取数据
        NetworkTools.shareInstance.loadStatuses(since_id, max_id: max_id) { (array, error) in
            
            //2.1安全校验
            if error != nil
            {
                finished(models: nil, error: error)
                return
            }
            
            //2.2将字典数组转换为模型数组
            var models = [StatusViewModel]()
            for dict in array!
            {
                let status = Status(dict: dict)
                let viewModel = StatusViewModel(status: status)
                models.append(viewModel)
            }
            
            //2.3处理微博数据
            if since_id != "0"
            {
                self.statuses = models + self.statuses!
            }
            else if max_id != "0"
            {
                self.statuses = self.statuses! + models
            }
            else
            {
                self.statuses = models
            }
            
            //2.4缓存微博所有配图
            self.cachesImages(models, finished: finished)
        }
    }
    
    /// 缓存微博配图
    private func cachesImages(viewModels: [StatusViewModel], finished: (models: [StatusViewModel]?, error: NSError?)->())
    {
        //0.创建一个组
        let group = dispatch_group_create()
        
        for viewModel in viewModels {
            
            //1.从模型中取出配图数组
            guard let picurls = viewModel.thumbnail_pic else
            {
                //如果当前微博没有配图就跳过, 继续下载下一个模型的
                continue
            }
            
            //2.遍历配图数组下载图片
            for url in picurls
            {
                //将当前的下载操作添加到组中
                dispatch_group_enter(group)
                
                //3.利用SDWebImage下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) in
                    
                    //将当前下载操作从组中移除
                    dispatch_group_leave(group)
                })
            }
            
        }
        
        //监听下载操作
        dispatch_group_notify(group, dispatch_get_main_queue())
        {
            finished(models: viewModels, error: nil)
        }
    }
    
}
