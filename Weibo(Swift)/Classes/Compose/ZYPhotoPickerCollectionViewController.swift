//
//  ZYPhotoPickerCollectionViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/10/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class ZYPhotoPickerCollectionViewController: UICollectionViewController {

    //定义存放用户选择的UIImage对象的数组
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return images.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //1.创建或取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ZYPhotoPickerCollectionViewCell
        cell.delegate = self
        
        //2.给cell设置数据
        cell.image = indexPath.item >= images.count ? nil : images[indexPath.item]
        
        //3.返回cell
        return cell
    }
}

extension ZYPhotoPickerCollectionViewController: ZYPhotoPickerCollectionViewCellDelegate
{
    func photoPickerCellAddPhotoBtnClick(cell: ZYPhotoPickerCollectionViewCell) {
        
        //1.判断照片源是否可用
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) else{
         
            print("照片源不可用")
            return
        }
        
        //2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
        //3.设置照片源
        ipc.sourceType = .PhotoLibrary
        
        //4.设置代理
        ipc.delegate = self
        
        //5.弹出照片选择控制器
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    func photoPickerCellRemovePhotoBtnClick(cell: ZYPhotoPickerCollectionViewCell) {
        
        //1.移除选中的照片
        let indexPath = collectionView!.indexPathForCell(cell)!
        images.removeAtIndex(indexPath.item)

        //2.刷新表格
        collectionView?.reloadData()
    }
}

extension ZYPhotoPickerCollectionViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //照片选择完成后
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //1.获取选择的照片
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        //2.退出控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        //3.用collectionView显示照片
        //3.0.压缩照片
        let newImage = drawImage(image, width: 450)
        
        //3.1.将照片存放到数组中
        images.append(newImage)
        
        //3.2.刷新表格
        collectionView?.reloadData()
    }
    
    func drawImage(image: UIImage, width: CGFloat) -> UIImage
    {
        //0.获取图片的size
        let height = (image.size.height / image.size.width) * width
        let size = CGSize(width: width, height: height)
        
        //1.开启图片上下文
        UIGraphicsBeginImageContext(size)
        
        //2.将图片画到上下文
        image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        //3.从上下文中获取新的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //4.关闭上下文
        UIGraphicsEndImageContext()
        
        //5.返回新的图片
        return newImage
    }
}

@objc protocol ZYPhotoPickerCollectionViewCellDelegate : NSObjectProtocol
{
    optional func photoPickerCellAddPhotoBtnClick(cell: ZYPhotoPickerCollectionViewCell)
    
    optional func photoPickerCellRemovePhotoBtnClick(cell: ZYPhotoPickerCollectionViewCell)
}

class ZYPhotoPickerCollectionViewCell: UICollectionViewCell {
    
    //代理属性
    var delegate: ZYPhotoPickerCollectionViewCellDelegate?
    
    //添加照片的button
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    //移除照片的button
    @IBOutlet weak var removePhotoBtn: UIButton!

    //UIImage接口的属性
    var image: UIImage?
    {
        didSet
        {
            if image == nil {
                addPhotoBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
                addPhotoBtn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
                addPhotoBtn.userInteractionEnabled = true
                removePhotoBtn.hidden = true
            }
            else{
                addPhotoBtn.setBackgroundImage(image, forState: UIControlState.Normal)
                addPhotoBtn.userInteractionEnabled = false
                removePhotoBtn.hidden = false
            }
        }
    }
    
    //监听添加照片button的点击
    @IBAction func addPhotoBtnClick()
    {
        if let tempDelegate = delegate {
            
            if tempDelegate.respondsToSelector(#selector(ZYPhotoPickerCollectionViewCellDelegate.photoPickerCellAddPhotoBtnClick(_:))) {
                
                tempDelegate.photoPickerCellAddPhotoBtnClick!(self)
            }
        }
    }
    
    //监听移除照片button的点击
    @IBAction func removeBtnClick()
    {
        if let tempDelegate = delegate {
            
            if tempDelegate.respondsToSelector(#selector(ZYPhotoPickerCollectionViewCellDelegate.photoPickerCellRemovePhotoBtnClick(_:))) {
                
                tempDelegate.photoPickerCellRemovePhotoBtnClick!(self)
            }
        }
    }
    
}

class ZYPhotoPickerCollectionViewFlowLayout: UICollectionViewFlowLayout
{
    override func prepareLayout() {
        super.prepareLayout()
        
        //1.定义常量
        let margin : CGFloat = 20
        let col : CGFloat = 3
        
        //2.计算item的宽度和高度,以及设置item的宽度和高度
        let itemWH = (collectionView!.bounds.width - margin * (col + 1)) / col
        itemSize = CGSize(width: itemWH, height: itemWH)
        
        //3.设置其他属性
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
        
        //4.设置内边距
        sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
    }
}
