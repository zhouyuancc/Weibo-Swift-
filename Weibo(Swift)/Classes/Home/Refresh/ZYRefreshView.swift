//
//  ZYRefreshView.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/10.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SnapKit

class ZYRefreshControl: UIRefreshControl{
    
    override init() {
        super.init()
        
        //1.添加子控件
        addSubview(refreshView)
        
        //2.布局子控件
        refreshView.snp_makeConstraints { (make) in
            
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.center.equalTo(self)
        }
        
        //3.监听UIRefreshControl frame改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        refreshView.stopLoadingView()
    }
    
    ///记录是否需要旋转
    var rotationFlag = false
    
    // MARK: - 内部控制方法
    deinit
    {
        removeObserver(self, forKeyPath: "frame")
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y == 0 || frame.origin.y == -64
        {
            //过滤掉垃圾数据
            return
        }
        
        //判断是否触发下拉刷新事件
        if refreshing {
            
            //隐藏提示视图,显示加载视图,并且让菊花转动
            refreshView.startLoadingView()
            return
        }
        
        //通过观察发现:往下拉Y越小,往上推Y越大
        if frame.origin.y < -50 && !rotationFlag
        {
            rotationFlag = true
            refreshView.rotationArrow(rotationFlag)
        }
        else if frame.origin.y > -50 && rotationFlag
        {
            rotationFlag = false
            refreshView.rotationArrow(rotationFlag)
        }
    }
    
    // MARK: - 懒加载
    private lazy var refreshView: ZYRefreshView = ZYRefreshView.refreshView()
}

class ZYRefreshView: UIView {

    ///菊花
    @IBOutlet weak var loadingImageView: UIImageView!
    
    ///提示视图
    @IBOutlet weak var tipView: UIView!
    
    ///箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    class func refreshView() -> ZYRefreshView {
        
        return NSBundle.mainBundle().loadNibNamed("ZYRefreshView", owner: nil, options: nil).last as! ZYRefreshView
    }
    
    // MARK: - 外部控制方法
    ///旋转箭头
    func rotationArrow(flag: Bool)
    {
        var angle: CGFloat = flag ? -0.01 : 0.01
        angle += CGFloat(M_PI)
        
        /**
         transform旋转动画默认是按照顺时针旋转的
         但是旋转式还有一个原则, 就近原则
         */
        UIView.animateWithDuration(2.0) { 
            
            self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, angle)
        }
    }
    
    ///显示加载视图
    func startLoadingView()
    {
        //0.隐藏提示视图
        tipView.hidden = true
        
        if let _ = loadingImageView.layer.animationForKey("lnj")
        {
            //如果已经添加过动画,就直接返回
            return
        }
        
        //1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        //2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        
        //3.将动画添加到图层上
        loadingImageView.layer.addAnimation(anim, forKey: "lnj")
    }
    
    ///隐藏加载视图
    func stopLoadingView()
    {
        //0.显示提示视图
        tipView.hidden = false
        
        //1.移除动画
        loadingImageView.layer.removeAllAnimations()
    }

}
