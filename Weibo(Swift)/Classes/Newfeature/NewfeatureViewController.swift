//
//  NewfeatureViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/8/18.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SnapKit

class NewfeatureViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    //新特性界面的个数
    private var maxCount = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置总页数
        pageControl.numberOfPages = 4
    }
}

extension NewfeatureViewController: UICollectionViewDataSource{
    
    //1.告诉系统有多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2.每组多少行
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return maxCount
    }
    
    //3.每行显示什么内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newfeatureCell", forIndexPath: indexPath) as! ZYNewfeatureCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.purpleColor()

        //2.设置数据
        cell.index = indexPath.item
        
        //3.返回cell
        return cell
    }
}

extension NewfeatureViewController: UICollectionViewDelegate{
    
    //完成展示cell
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        //注意 : 传入的cell和indexPath都是上一页的,而不是当前页
        //1.手动获取当前显示的cell对应的indexPath
        let index = collectionView.indexPathsForVisibleItems().last!
        ZYLog(indexPath.item)
        //2.根据指定的indexPath获取当前显示的cell
        let currentCell = collectionView.cellForItemAtIndexPath(index) as! ZYNewfeatureCell
        
        //设置当前页数
        pageControl.currentPage = currentCell.index
        
        //3.判断当前是否是最后一页
        if index.item == (maxCount - 1)
        {
            //做动画
            currentCell.startAnimation()
        }
    
    }
}

// MARK: - 自定义Cell
class ZYNewfeatureCell: UICollectionViewCell {
    
    var index: Int = 0
        {
        didSet{
            
            //1.生成图片名称
            let name = "new_feature_\(index + 1)"
            //2.设置图片
            iconView.image = UIImage(named: name)
            startButton.hidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //初始化UI
        setupUI()
    }
    
    // MARK: - 外部控制方法
    func startAnimation() {
        
        startButton.hidden = false
        //执行放大动画
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startButton.userInteractionEnabled = false
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { 
                self.startButton.transform = CGAffineTransformIdentity
            }) { (_) in
                
                self.startButton.userInteractionEnabled = true
        }
    }
    
    // MARK: - 内部控制方法
    private func setupUI() {
        //1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        //2.布局子控件
        iconView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        startButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-160)
        }
    }
    
    @objc private func startBtnClick()
    {
        //跳转到首页
        NSNotificationCenter.defaultCenter().postNotificationName(ZYSwitchRootViewController, object: true)
    }
    
    // MARK: - 懒加载
    //图片容器
    private lazy var iconView = UIImageView()
    
    //开始按钮
    private lazy var startButton : UIButton = {
       
        let btn = UIButton(imageName: nil, backgroundImageName: "new_feature_button")
        btn.addTarget(self, action: #selector(ZYNewfeatureCell.startBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
}

// MARK: - 自定义布局
class ZYNewfeatureLayout: UICollectionViewFlowLayout
{
    //准备布局
    override func prepareLayout() {
        //1.设置每个cell的尺寸
        itemSize = UIScreen.mainScreen().bounds.size
        //2.设置cell之间的间隙
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        //3.设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        //4.设置分页
        collectionView?.pagingEnabled = true
        //5.禁止回弹
        collectionView?.bounces = false
        //6.取出滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
