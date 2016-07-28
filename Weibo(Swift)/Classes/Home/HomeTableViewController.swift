//
//  HomeTableViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/14.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

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
        

    }
// MARK: - 内部控制
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
        let titleButton = TitleButton()
        titleButton.setTitle("首页", forState: UIControlState.Normal)
//        覆盖TitleButton的image Normal
//        titleButton.setImage(UIImage(named: "navigationbar_friendattention"), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleButton
    }
    
    @objc private func titleBtnClick(btn:TitleButton)
    {
        //1.修改按钮的状态
        btn.selected = !btn.selected
        
        //2.显示菜单
        //2.1创建菜单//从新建的Popover.storyboard中创建UIViewController
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else
        {
            return;
        }
        //自定义转场动画
        menuView.transitioningDelegate = self
        //设置转场代理
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        //2.2弹出菜单
        presentViewController(menuView, animated: true, completion: nil)
    }
    
    @objc private func leftBtnClick() {
        ZYLog("")
        
    }
    @objc private func rightBtnClick() {
        ZYLog("")
    }
    
    //定义标记记录当前是否是展现
    private var isPresent = false
}

extension HomeTableViewController: UIViewControllerTransitioningDelegate
{
    //该方法用于返回一个负责转场动画的对象
    //可以在该对象中控制弹出视图
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        return ZYPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    //该方法用于返回一个负责转场如何 出现 的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        return self
    }
    
    //该方法用于返回一个负责转场如何 消失 的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        return self
    }

}

extension HomeTableViewController:UIViewControllerAnimatedTransitioning
{
    //告诉系统展示和消失的动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    /**
     用于管理modal展示和消失,无论是 展示或消失 都会调用该方法
     注意点 : 只要实现了这个代理方法,系统就不会再有默认的动画了.
     即: 默认的modal从下至上的移动,系统不再帮我们添加.
         1.所有的动画操作都需要我们自己实现
         2.需要展示的视图 也需要我们自己添加到容器视图(containerView)上
     */
    //transitionContext : 所有动画需要的东西都保存在上下文中.
    //即: 可以通过transitionContext获取需要的数据
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        //判断当前是展示还是消失
        if isPresent {
            
            //展示
            //1.获取需要弹出的视图
//            let toVc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//            
//            let fromVc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
//            ZYLog(toVc)
//            ZYLog(fromVc)
            
            //通过ToViewKey取出的就是toVC对应的view
            guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else{
                return
            }
            
            //2.将需要弹出的视图添加到containerView上
            transitionContext.containerView()?.addSubview(toView)
            
            //3.执行动画
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            //设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)

            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                () -> Void in
                //动画恢复
                toView.transform = CGAffineTransformIdentity
            }){
                (_) -> Void in
                //注意 : 自定义转场动画,在执行完动画之后一定要告诉系统--动画执行完毕了
                transitionContext.completeTransition(true)
            }
            
        }
        else
        {
            //消失
            //1.拿到需要消失的视图
            guard let fromView  = transitionContext.viewForKey(UITransitionContextFromViewKey) else{
                return
            }
            
            //2.执行动画让视图消失
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                
                //突然消失的原因 : CGFloat不准确,导致无法执行动画
                //解决方法 : 将CGFloat的值设置为一个很小的值即可
                fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001)
                
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}

