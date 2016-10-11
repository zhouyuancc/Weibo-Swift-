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
    var statusListModel: StatusListModel = StatusListModel()

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.showBrowser(_:)), name: ZYShowPhotoBrowserController, object: nil)
        
        
        //4.获取微博数据
        loadData()
        
        //5.设置tableView
        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //6.初始化刷新
        refreshControl = ZYRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.beginRefreshing()
        
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
    }
    
    deinit
    {
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 内部控制
    @objc private func loadData() {
        
        statusListModel.loadData(lastStatus) { (models, error) in
            
            //1.安全校验
            if error != nil
            {
                SVProgressHUD.showErrorWithStatus("获取微博数失败", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            //2.关闭菊花
            self.refreshControl?.endRefreshing()
            
            //3.显示刷新提醒
            self.showRefreshStautus(models!.count)
            
            //4.刷新表格
            self.tableView.reloadData()
        }
    }
    
    ///显示刷新提醒
    private func showRefreshStautus(count: Int)
    {
        //1.设置提醒文本
        tipLabel.text = (count == 0) ? "没有更多数据" : "刷新到\(count)数据"
        tipLabel.hidden = false
        
        //2.执行动画
        UIView.animateWithDuration(1.0, animations: { 
            self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44)
            }) { (_) in
                
                UIView.animateWithDuration(1.0, delay: 2.0, options: UIViewAnimationOptions(rawValue: 0), animations: { 
                    
                        self.tipLabel.transform = CGAffineTransformIdentity
                    
                    }, completion: { (_) in
                        
                        self.tipLabel.hidden = true
                })
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
    
    ///监听图片点击通知
    @objc private func showBrowser(notice: NSNotification)
    {
        //注意: 但凡是通过网络或者通知获取到的数据, 都需要进行安全校验
        guard let pictures = notice.userInfo!["bmiddle_pic"] as? [NSURL] else{
            
            SVProgressHUD.showErrorWithStatus("没有图片", maskType: SVProgressHUDMaskType.Black)
            return
        }
        guard let index = notice.userInfo!["indexPath"] as? NSIndexPath else{
            
            SVProgressHUD.showErrorWithStatus("没有索引", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        //弹出图片浏览器, 将所有图片和当前点击的索引传递给浏览器
        let vc = ZYBrowserViewController(bmiddle_pic: pictures, indexPath: index)
        presentViewController(vc, animated: true, completion: nil)
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
    
    //刷新提醒视图
    private var tipLabel: UILabel = {
        
        let lb = UILabel()
        lb.backgroundColor = UIColor.orangeColor()
        lb.text = "没有更多数据"
        lb.textColor = UIColor.whiteColor()
        lb.font = UIFont.systemFontOfSize(13)
        lb.textAlignment = NSTextAlignment.Center
        let width = UIScreen.mainScreen().bounds.width
        
        lb.frame = CGRect(x: 0, y: 0, width: width, height: 32)
        lb.hidden = true
        return lb
    }()
    
    //最后一条微博标记
    private var lastStatus = false
}

extension HomeTableViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListModel.statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let viewModel = statusListModel.statuses![indexPath.row]
        let identifier = (viewModel.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        
        //1.取出cell
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        //2.设置数据
        cell.viewModel = viewModel
        
        //3.判断是否是最后一条微博
        if indexPath.row == (statusListModel.statuses!.count - 1) {
            
            ZYLog("最后一条微博 \(viewModel.status.user?.screen_name)")
            
            lastStatus = true
            loadData()
        }
        
        //4.返回cell
        return cell
    }
    
    //返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let viewModel = statusListModel.statuses![indexPath.row]
        let identifier = (viewModel.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        
        //1.用缓存中获取行高
        guard let height = rowHeightCaches[viewModel.status.idstr ?? "-1"]
            else
        {
            //缓存中没有行高
//            ZYLog("计算行高")
            
            //2.计算行高
            //2.1获取当前行对应的cell
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! HomeTableViewCell
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

