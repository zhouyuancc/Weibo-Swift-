//
//  ZYPresentationManager.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/29.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

//自定义转场展示
let ZYPresentationManagerDidPresented = "ZYPresentationManagerDidPresented"
//自定义转场消失
let ZYPresentationManagerDidDismissed = "ZYPresentationManagerDidDismissed"

class ZYPresentationManager: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {

    //定义标记记录当前是否是展示状态
    private var isPresent = false
    
    //保存菜单的尺寸
    var presentFrame = CGRectZero
    
    // MARK: - UIViewControllerTransitioningDelegate
    //该方法用于返回一个负责转场动画的对象
    //可以在该对象中控制弹出视图
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = ZYPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame = presentFrame//HomeTableViewController -> ZYPresentationManager(当前) -> ZYPresentationController
        return pc
    }
    
    //该方法用于返回一个负责转场如何 出现 的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        
        //发送一个通知,告诉调用者这状态发生了改变
        NSNotificationCenter.defaultCenter().postNotificationName(ZYPresentationManagerDidPresented, object: self)
        
        return self
    }
    
    //该方法用于返回一个负责转场如何 消失 的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        
        //发送一个通知,告诉调用者这状态发生了改变
        NSNotificationCenter.defaultCenter().postNotificationName(ZYPresentationManagerDidDismissed, object: self)
        
        return self
    }
    
    // MARK: - UIPresentationController
    // MARK: - UIViewControllerAnimatedTransitioning
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
            willPresentedController(transitionContext)
        }
        else{
            //消失
            willDissmissedController(transitionContext)
        }
    }
    
    //执行展示动画
    private func willPresentedController(transitionContext:UIViewControllerContextTransitioning){
        
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
        /**
         慢慢展开 控制控件的高度
         x不变 y开始时设为0.0
         */
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)//缩放//x方向不变,y方向变为0
        //设置锚点
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            //弹出视图 清空transform属性,还原成原来的视图尺寸
            //操作popover.storyboard
            //动画恢复
            toView.transform = CGAffineTransformIdentity
            }) { (_) in//_ : 忽略这个值
                //注意 : 自定义转场动画,在执行完动画之后一定要告诉系统--动画执行完毕了
                transitionContext.completeTransition(true)
        }
    }
    
    //执行消失动画
    private func willDissmissedController(transitionContext:UIViewControllerContextTransitioning)
    {
        //消失
        //1.拿到需要消失的视图
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else{
            return
        }
        
        //2.执行动画让视图消失
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            //弹出视图的尺寸从原尺寸 -> CGRectZero
            //操作popover.storyboard
            //突然消失的原因 : CGFloat不准确,导致无法执行动画
            //解决方法 : 将CGFloat的值设置为一个很小的值即可
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001)//x方向不变,y方向变为0
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
    
}
