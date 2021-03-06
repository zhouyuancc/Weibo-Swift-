//
//  ComposeTitleView.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class ComposeTitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI()
    {
        addSubview(titleLabel)
        addSubview(nameLabel)
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom)
        }
    }
    
    // MARK: - 懒加载
    private lazy var titleLabel: UILabel = {
        
        let lb = UILabel()
        lb.textColor = UIColor.darkGrayColor()
        lb.text = "发微博"
        return lb
    }()
    
    private lazy var nameLabel: UILabel = {
        
        let lb = UILabel()
        lb.textColor = UIColor.lightGrayColor()
        lb.font = UIFont.systemFontOfSize(15)
        lb.text = UserAccount.loadUserAccount()?.screen_name ?? ""
        return lb
    }()
}
