//
//  WelcomeViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/8/18.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    //头像底部约束
    @IBOutlet weak var iconBottomCons: NSLayoutConstraint!
    //标题
    @IBOutlet weak var titleLabel: UILabel!
    //头像容器
    @IBOutlet weak var iconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置头像圆角
        iconImageView.layer.cornerRadius = 45
        iconImageView.clipsToBounds = true
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能显示欢迎界面")
        
        //2.设置头像
        ZYLog(UserAccount.loadUserAccount()?.avatar_large)
        
        guard let url = NSURL(string: UserAccount.loadUserAccount()!.avatar_large!) else
        {
            return
        }
        iconImageView.sd_setImageWithURL(url)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //让头像执行动画
        
        iconBottomCons.constant = (UIScreen.mainScreen().bounds.height - iconBottomCons.constant)
        
        UIView.animateWithDuration(2.0, animations: {
            
            self.view.layoutIfNeeded()
            
            }) { (_) in//completion
                
                UIView.animateWithDuration(2.0, animations: { 
                    self.titleLabel.alpha = 1.0
                    }, completion: { (_) in
                        //跳转到首页
//                        let sb = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = sb.instantiateInitialViewController()!
//                        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
                       
                        NSNotificationCenter.defaultCenter().postNotificationName(ZYSwitchRootViewController, object: true)
                })
        }
        
        
    }


}
