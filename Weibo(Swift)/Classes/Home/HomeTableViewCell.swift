//
//  HomeTableViewCell.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/4.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
    
    //配图视图
    @IBOutlet weak var pictureCollectionView: ZYPictureView!
    
    //头像
    @IBOutlet weak var iconImageView: UIImageView!
    
    //认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    
    //昵称
    @IBOutlet weak var nameLabel: UILabel!
    
    //会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    //正文
    @IBOutlet weak var contentLabel: UILabel!
    
    //底部视图
    @IBOutlet weak var footerView: UIView!
    
    //转发正文
    @IBOutlet weak var forwardLabel: UILabel!
    
    //picture Collection View与footerView间的约束
    @IBOutlet weak var picCollectionViewCellBottom: NSLayoutConstraint!
    
    //模型数据
    var viewModel: StatusViewModel?
    {
        didSet{
            
            //1.设置头像
            iconImageView.sd_setImageWithURL(viewModel?.icon_URL)
            
            //2.设置认证图标
            verifiedImageView.image = viewModel?.verified_image
            
            //3.设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            //4.设置会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.blackColor()
            if let image = viewModel?.mbrankImage
            {
                vipImageView.image = image
                nameLabel.textColor = UIColor.orangeColor()
            }
            
            //5.设置时间
            timeLabel.text = viewModel?.created_Time
            
            //6.设置来源
            sourceLabel.text = viewModel?.source_Text
            
            //7.设置正文
            contentLabel.text = viewModel?.status.text
            
            //8.1更新配图
            pictureCollectionView.viewModel = viewModel
            
            //8.2更新picture Collection View与footerView间的约束
            //转发,没有图片时,设置CollectionViewCell与下面的边距为0
            if viewModel?.thumbnail_pic?.count == 0 {
                
                picCollectionViewCellBottom.constant = 0
            }
            else
            {
                picCollectionViewCellBottom.constant = 10
            }
            
            
            //10.转发微博
            if let text = viewModel?.forwardText
            {
                forwardLabel.text = text
                forwardLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 10
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 10
    }
    
    // MARK: - 外部控制方法
    func calculateRowHeight(viewModel: StatusViewModel) -> CGFloat
    {
        //1.设置数据
        self.viewModel = viewModel
        
        //2.更新UI
        self.layoutIfNeeded()
        
        //3.返回底部视图最大的Y
        return CGRectGetMaxY(footerView.frame)
    }

}

