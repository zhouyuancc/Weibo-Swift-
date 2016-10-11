//
//  ZYBrowserViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/9.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SDWebImage

class ZYBrowserViewController: UIViewController {
    
    ///所有配图
    var bmiddle_pic: [NSURL]
    
    ///当前点击的索引
    var indexPath: NSIndexPath
    
    init(bmiddle_pic: [NSURL], indexPath: NSIndexPath)
    {
        self.bmiddle_pic = bmiddle_pic
        self.indexPath = indexPath
        
        //注意: 自定义构造方法时候不一定是调用super.init(),需要调用当前类设计构造方法(designated)
        super.init(nibName: nil, bundle: nil)
        
        //初始化
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        //1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        //2.布局子控件
        //2.1.collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(cons)
        
        
        //2.2.关闭按钮|保存按钮
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        let dict = ["closeButton":closeButton, "saveButton":saveButton]
        
        let closeHCons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[closeButton(100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let closeVCons = NSLayoutConstraint.constraintsWithVisualFormat("V:[closeButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(closeHCons)
        view.addConstraints(closeVCons)
        
        let saveHCons = NSLayoutConstraint.constraintsWithVisualFormat("H:[saveButton(100)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let saveVCons = NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(saveHCons)
        view.addConstraints(saveVCons)
    }
    
    @objc private func closeBtnClick()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func saveBtnClick()
    {
        
    }
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: ZYBrowserLayout())
        
        clv.dataSource = self
        clv.registerClass(ZYBrowserCell.self, forCellWithReuseIdentifier: "browserCell")
        
        return clv
    }()
    
    private lazy var closeButton: UIButton = {
    
        let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(ZYBrowserViewController.closeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var saveButton: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(ZYBrowserViewController.saveBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()

}

extension ZYBrowserViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bmiddle_pic.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("browserCell", forIndexPath: indexPath) as! ZYBrowserCell
        
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        cell.imageURL = bmiddle_pic[indexPath.item]
        
        return cell
    }
}

///自定义布局
class ZYBrowserLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}