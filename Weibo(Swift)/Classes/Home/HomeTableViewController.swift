//
//  HomeTableViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/14.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeTableViewController: BaseTableViewController {

    //保存所有微博数据
    var statuses: [StatusViewModel]?
    {
        didSet
        {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.判断用户是否登录
        if !isLogin {//没登录
            //设置访客视图
            visitorView?.setupVisitorInfo(nil, title: "关注一些人,回这里看看有什么惊喜")
            return
        }
        
        //2.初始化导航条
        setupNav()
        
        //3.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: ZYPresentationManagerDidPresented, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: ZYPresentationManagerDidDismissed, object: animatorManager)
        
        //4.获取微博数据
        loadData()
        
        tableView.estimatedRowHeight = 400
    }
    
    deinit
    {
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 内部控制
    private func loadData() {
        
        NetworkTools.shareInstance.loadStatuses { (array, error) in
            
            //1.安全校验
            if error != nil
            {
                SVProgressHUD.showErrorWithStatus("获取微博数据失败", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            guard let arr = array else{
                
                //数组是空的
                return
            }
            
//            ZYLog(arr)
            
            //2.将字典数组转换为模型数组
            //2.1 创建一个 模型 数组
            var models = [StatusViewModel]()
            
            for dict in arr{
                
                //2.2 dict转模型(dict字典子级字典,转User模型)
                let status = Status(dict: dict)
                
                //2.3 通过字典模型 转 view展示需要的模型
                let viewModel = StatusViewModel(status: status)
                
//                ZYLog(viewModel)
                
                //2.4 将 view模型 添加到 数组
                models.append(viewModel)
            }
            
            //3.保存微博数据
            //注意:显示图片依赖于配图,所以只好下载好了图片才能刷新表格
//            self.statuses = models
            
            //4.缓存微博所有配图
            self.cachesImages(models)
        }
    }
    
    //缓存微博配图
    private func cachesImages(viewModels: [StatusViewModel])
    {
        //0.创建一个组
        let group = dispatch_group_create()
        
        for viewModel in viewModels {
            
            //1.从模型中取出配图数组
            guard let picurls = viewModel.thumbnail_pic else
            {
                //如果当前微博没有配图就跳过,继续下载下一个模型的
                //跳过
                continue
            }
            
            //2.遍历配图数组下载图片
            for url in picurls {
                
                //将 当前的下载操作 添加到 组中
                dispatch_group_enter(group)
                
                //3.利用SDWebImage下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) in
                    
//                    ZYLog("图片下载完成")
                    
                    //将 当前下载操作 从组中 移除
                    dispatch_group_leave(group)
                })
            }
        }
        
        //监听下载操作
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            
//            ZYLog("全部下载完成")
            self.statuses = viewModels
        }
        
    }
    
    
    /**
     添加导航条按钮
     */
    private func setupNav()
    {
        //1.添加左右按钮
        //UIBarButtonItem+Extension.swift分类
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        //2.添加标题按钮
        navigationItem.titleView = titleButton
    }
    
    @objc private func titleChange()
    {
        titleButton.selected = !titleButton.selected
    }
    
    @objc private func titleBtnClick(btn:TitleButton)
    {
        //1.修改按钮的状态
//        btn.selected = !btn.selected
        
        //2.显示菜单
        //2.1创建菜单//从新建的Popover.storyboard中创建UIViewController
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else
        {
            return;
        }
        //自定义转场动画
        menuView.transitioningDelegate = animatorManager
        //设置转场代理
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        //2.2弹出菜单
        presentViewController(menuView, animated: true, completion: nil)
    }
    
    @objc private func leftBtnClick() {
        ZYLog("")
        
    }
    @objc private func rightBtnClick() {

        //1.创建二维码控制器
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.弹出二维码控制器
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var animatorManager: ZYPresentationManager = {
        
        //: ZYPresentationManager 明确指定数据类型
       
        let manager = ZYPresentationManager()
        manager.presentFrame = CGRect(x: 100, y: 52, width: 200, height: 200)
        return manager
    }()
    
    //标题按钮
    private lazy var titleButton: TitleButton = {
        
        let btn = TitleButton()
        
        let title = UserAccount.loadUserAccount()?.screen_name
        
        btn.setTitle(title, forState: UIControlState.Normal)
        //        覆盖TitleButton的image Normal
        //        titleButton.setImage(UIImage(named: "navigationbar_friendattention"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    //缓存行高
    private var rowHeightCaches = [String: CGFloat]()
}

extension HomeTableViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //1.取出cell
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as! HomeTableViewCell
        
        //2.设置数据
        cell.viewModel = statuses![indexPath.row]
        
        //3.返回cell
        return cell
    }
    
    //返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let viewModel = statuses![indexPath.row]
        
        //1.用缓存中获取行高
        guard let height = rowHeightCaches[viewModel.status.idstr ?? "-1"]
            else
        {
            //缓存中没有行高
//            ZYLog("计算行高")
            
            //2.计算行高
            //2.1获取当前行对应的cell
            let cell = tableView.dequeueReusableCellWithIdentifier("homeCell") as! HomeTableViewCell
            //2.2缓存行高
            let temp = cell.calculateRowHeight(viewModel)
            
            rowHeightCaches[viewModel.status.idstr ?? "-1"] = temp
            
            //3.返回行高
            return temp
        }
        
        //缓存中有行高,直接返回缓存中的高度
        return height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //释放缓存数据
        rowHeightCaches.removeAll()
    }
    
}

