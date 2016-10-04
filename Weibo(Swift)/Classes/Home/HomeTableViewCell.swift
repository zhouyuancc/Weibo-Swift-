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
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    //配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    
    //配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    
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
            
            //8.更新配图
            pictureCollectionView.reloadData()
            
            //9.更新配图尺寸 
            //计算cell和collectionView的尺寸
            let (itemSize,clvSize) = calculateSize()
            
            //9.1更新cell的尺寸
            if itemSize != CGSizeZero
            {
                flowLayout.itemSize = itemSize
            }
            
            //9.2更新collectionView尺寸
            pictureCollectionViewHeightCons.constant = clvSize.height
            pictureCollectionViewWidthCons.constant = clvSize.width
            
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
    
    // MARK: - 内部控制方法
    //计算cell和collectionView的尺寸
    private func calculateSize() -> (CGSize, CGSize)
    {
        /**
         配图 张数
         0 : cell = zero , collectionView = zero
         1 : cell = image.size , collectionView = image.size
         4 : cell = {90 , 90} , collectionView = {2 * w + m , 2 * h + m}
         其他 : cell = {90 , 90}
         */
        let count = viewModel?.thumbnail_pic?.count ?? 0
        
        //没有配图
        if count == 0 {
            return (CGSizeZero, CGSizeZero)
        }
        
        //一张配图
        if count == 1
        {
            let key = viewModel?.thumbnail_pic?.first?.absoluteString
            
            //从缓存中获取已经下载好的图片,其中key是图片的url
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            
            return (image.size, image.size)
        }
        
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        let imageMargin: CGFloat = 10
        
        var col: Int
        var row: Int
        
        //四张配图
        if count == 4
        {
            col = 2
            row = col
        }
        else
        {
            //其他张配图
            col = 3
            row = (count - 1) / 3 + 1
        }
        
        //宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        //高度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        
        return (CGSize(width: imageWidth, height: imageHeight),CGSize(width: width, height: height))
    }
}

extension HomeTableViewCell: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! HomePictureCell
        
        cell.url = viewModel?.thumbnail_pic![indexPath.item]
        
        return cell
    }
}

class HomePictureCell: UICollectionViewCell {
    var url: NSURL?
    {
        didSet
        {
            customIconImageView.sd_setImageWithURL(url)
        }
    }
    
    @IBOutlet weak var customIconImageView: UIImageView!
}
