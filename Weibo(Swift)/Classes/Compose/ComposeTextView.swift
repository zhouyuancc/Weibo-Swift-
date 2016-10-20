//
//  ComposeTextView.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/17.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class ComposeTextView: ZYKeyboardTextView, UITextViewDelegate {
    
    init()
    {
        super.init(frame: CGRectZero, textContainer: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(placeholderLabel)
        
        // 2.布局子控件
        placeholderLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.top.equalTo(8)
        }
    }
    
    // MARK: - 懒加载
    lazy var placeholderLabel: UILabel = {
        let lb = UILabel()
        lb.text = "分享新鲜事..."
        lb.textColor = UIColor.lightGrayColor()
        lb.font = self.font
        return lb
    }()
}


