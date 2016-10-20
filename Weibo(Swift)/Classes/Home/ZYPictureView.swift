//
//  ZYPictureView.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/9.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SDWebImage

class ZYPictureView: UICollectionView {
    
    //配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    
    //配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dataSource = self
        self.delegate = self
    }
    
    var viewModel: StatusViewModel?
        {
        didSet
        {
            //8.更新配图
            reloadData()
            
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
            
            ZYLog(key)
            
            //从缓存中获取已经下载好的图片,其中key是图片的url
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
// MARK: - SDWebImageManager获取得来的尺寸小
//            ZYLog(image.size)
            return (image.size, image.size)
        }
        
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        let imageMargin: CGFloat = 10
        
        //其他张配图
        var col = 3
        var row = (count - 1) / 3 + 1
        
        //四张配图
        if count == 4
        {
            col = 2
            row = col
        }
        
        //宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        //高度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        
        return (CGSize(width: imageWidth, height: imageHeight),CGSize(width: width, height: height))
        
//        // 四张配图
//        if count == 4
//        {
//            let col = 2
//            let row = col
//            // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
//            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
//            // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
//            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
//            return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
//        }
//        
//        // 其他张配图
//        let col = 3
//        let row = (count - 1) / 3 + 1
//        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
//        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
//        // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
//        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
//        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
    }
    
}

extension ZYPictureView: UICollectionViewDataSource,UICollectionViewDelegate
{
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! HomePictureCell
        
        cell.url = viewModel?.thumbnail_pic![indexPath.item]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        ZYLog(viewModel?.thumbnail_pic)
        //0.获取当前点击图片的URL
        let url = viewModel!.bmiddle_pic![indexPath.item]
        
        //取出被点击的cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! HomePictureCell
        
        //1.下载图片, 设置进度
        SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: { (current, total) in
            
            cell.customIconImageView.progress = CGFloat(current) / CGFloat(total)
            
            }) { (_, error, _, _, _) in
                
                //2.弹出一个控制器(图片浏览器),告诉控制器那些图片需要展示,告诉控制器当前展示哪一张
                NSNotificationCenter.defaultCenter().postNotificationName(ZYShowPhotoBrowserController, object: self, userInfo: ["bmiddle_pic": self.viewModel!.bmiddle_pic!, "indexPath": indexPath])
        }
        
        
    }
}

class HomePictureCell: UICollectionViewCell
{
    var url: NSURL?
        {
        didSet
        {
            //1.设置图片
            customIconImageView.sd_setImageWithURL(url)
            
            //2.控制gif图标的显示和隐藏
            if let flag = url?.absoluteString.lowercaseString.hasSuffix("gif")
            {
                gifImageView.hidden = !flag
            }
        }
    }
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var customIconImageView: ZYProgressImageView!
}
