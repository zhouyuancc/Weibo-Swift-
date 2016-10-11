//
//  ZYBrowserCell.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/9.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class ZYBrowserCell: UICollectionViewCell, UIScrollViewDelegate {

    var imageURL: NSURL?
    {
        didSet
        {
            //显示菊花提醒
            indicatorView.startAnimating()
            
            //重置容器所有数据
            resetView()
            
            //设置图片
            imageView.sd_setImageWithURL(imageURL) { (image, error, _, url) in
                
                //0.关闭菊花提醒
                self.indicatorView.stopAnimating()
                
                let width = UIScreen.mainScreen().bounds.width
                let height = UIScreen.mainScreen().bounds.height
                
                //1.计算当前图片的宽高比
                let scale = image.size.height / image.size.width
                
                //2.利用宽高比乘以屏幕宽度,等比缩放图片
                let imageHeight = scale * width
                
                //3.设置图片frame
                self.imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: width, height: imageHeight))
                
                //4.判断当前是长图还是短图
                if imageHeight < height {
                    
                    //短图
                    //5.计算顶部和底部内边距
                    let offsetY = (height - imageHeight) * 0.5
                    
                    //6.设置内边距
                    self.scrollview.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
                }
                else
                {
                    self.scrollview.contentSize = CGSize(width: width, height: imageHeight)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 内部控制方法
    private func resetView()
    {
        scrollview.contentSize = CGSizeZero
        scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentOffset = CGPointZero
        
        imageView.transform = CGAffineTransformIdentity
    }
    
    private func setupUI()
    {
        //1.添加子控件
        contentView.addSubview(scrollview)
        scrollview.addSubview(imageView)
        contentView.addSubview(indicatorView)
        
        //2.布局子控件
        scrollview.frame = UIScreen.mainScreen().bounds //self.frame
        scrollview.backgroundColor = UIColor.darkGrayColor()
        indicatorView.center = contentView.center
    }
    
    // MARK: - 懒加载
    private lazy var scrollview: UIScrollView = {
    
        let sc = UIScrollView()
        
        //最大和最小的缩放的比例，默认值都为1.0
        sc.maximumZoomScale = 2.0
        sc.minimumZoomScale = 0.5
        
        sc.delegate = self
        
        return sc
    }()
    
    private lazy var imageView: UIImageView = UIImageView()
    
    //提示视图
    private lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    // MARK: - UIScrollViewDelegate
    //告诉系统需要缩放哪个控件
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    //缩放的过程中会不断调用
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        //1.计算上下内边距
        var offsetY = (height - imageView.frame.height) * 0.5
        
        //2.计算左右内边距
        var offsetX = (width - imageView.frame.width) * 0.5
        
        offsetY = (offsetY < 0) ? 0 : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
        
        scrollview.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
}
