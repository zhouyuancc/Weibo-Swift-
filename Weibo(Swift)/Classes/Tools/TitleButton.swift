//
//  TitleButton.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/25.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

//    /**
//     设置title位置
//     */
//    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
//        return CGRectZero
//    }
//    /**
//     设置image位置
//     */
//    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
//        return CGRectZero
//    }
    
    /**
     通过纯代码创建时调用
     在Swift中如果重写父类方法,必须在方法前面加override
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    /**
     通过XIB/SB创建时调用
     */
    required init?(coder aDecoder: NSCoder) {
        //系统对initWithCoder的
//        fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    private func setupUI()
    {
        setImage(UIImage(named:
            "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        sizeToFit()
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        
        /**
         (title ?? "")
         ?? : 判断前面参数title是否为nil
              为nil -> "";不为nil -> title
              若为nil : 返回??后面的数据"";不为nil,不执行??后的语句,title ?? ""相当于title
         */
        super.setTitle((title ?? "") + "  ", forState: state)
    }
    
    /**
     重新布局子控件
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /*
        //offsetInPlace 方法用于设置控件的偏移量
        titleLabel?.frame.offsetInPlace(dx: -imageView!.frame.width * 0.5, dy: 0)
        imageView?.frame.offsetInPlace(dx: titleLabel!.frame.width * 0.5, dy: 0)
         */
        
        //和OC不太一样,Swift语法允许我们直接修改一个对象的结构体属性的成员
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
        
    }

}
