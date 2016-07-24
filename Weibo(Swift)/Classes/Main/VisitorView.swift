//
//  VisitorView.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/22.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    //转盘
    @IBOutlet weak var rotationImageView: UIImageView!
    //图标
    @IBOutlet weak var iconImageView: UIImageView!
    //文本标签
    @IBOutlet weak var titleLabel: UILabel!
    //注册按钮
    @IBOutlet weak var rigisterButton: UIButton!
    //登录按钮
    @IBOutlet weak var loginButton: UIButton!
    
    //设置访客视图上的数据
    //imageName图标
    //title标题
    func setupVisitorInfo(imageName: String?, title:String) {
        
        //1.设置标题
        titleLabel.text = title
        //2.判断是否是首页
        guard let name = imageName else{
            //没有设置图标,是首页
            //执行转盘动画
            startAnimation()
            
            return;
        }
        //3.设置其他数据
        //不是首页
        iconImageView.image = UIImage(named: name)
        //隐藏转盘
        rotationImageView.hidden = true
    }
    
    //转盘旋转动画
    private func startAnimation() {
        //1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        //2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 10.0
        anim.repeatCount = MAXFLOAT
        
        //注意: 默认情况下只要视图消失,系统就会自动移除动画
        //只要设置removedOnCompletion为false,系统就不会移除动画;当控制器销毁时,才会移除
        anim.removedOnCompletion = false//当结束时,不移除动画
        
        //3.将动画添加到图层上
        rotationImageView.layer.addAnimation(anim, forKey: nil)
    }
    
    //func == -
    //class func == +
    class func visitorView() -> VisitorView{
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).last as! VisitorView
    }

    

}
