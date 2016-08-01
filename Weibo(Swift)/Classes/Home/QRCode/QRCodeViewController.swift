//
//  QRCodeViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/7/29.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    /**
     扫描容器
     */
    @IBOutlet weak var customContainerView: UIView!
    /**
     扫描结果文本
     */
    @IBOutlet weak var customLabel: UILabel!
    /**
     底部工具条
     */
    @IBOutlet weak  var customTabbar: UITabBar!
    /**
     冲击波视图
     */
    @IBOutlet weak var scanLineView: UIImageView!
    /**
     容器视图高度约束
     */
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /**
     冲击波顶部的约束
     */
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置默认选中
        customTabbar.selectedItem = customTabbar.items?.first
        
        //2.添加监听,监听底部工具条的点击
        customTabbar.delegate = self
        
        //3.开始扫描二维码
        scanQRCode()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    // MARK: - 内部控制方法
    /**
     扫描二维码
     */
    private func scanQRCode()
    {
        //1.判断 输入 能否添加 到会话中
        if !session.canAddInput(input)
        {
            return
        }
        //2.判断 输出 能否添加 到会话中
        if !session.canAddOutput(output) {
            return
        }
        //能添加
        
        //3.添加 输入和输出 到会话中
        session.addInput(input)
        session.addOutput(output)
        
        //4.设置输出能够解析的数据类型
        //注意 : 设置 数据类型 一定要在 输出对象添加到会话之后
        output.metadataObjectTypes = output.availableMetadataObjectTypes//所有数据类型
        
        //5.设置监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        //6.添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        previewLayer.frame = view.bounds
        
        //7.添加容器图层(二维码描边)
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        
        //8.开始扫描
        session.startRunning()
    }
    /**
     开启冲击波动画
     */
    private func startAnimation()
    {
        //1.设置冲击波底部和容器视图顶部对齐
        scanLineCons.constant = -containerHeightCons.constant
        //3.强制更新
        view.layoutIfNeeded()
        
        //2.执行扫描动画
        // 在Swift中一般情况下不用写self, 也不推荐我们写self
        // 优点可以提醒程序员主动思考当前self会不会形成循环引用
        /**
         一般情况下只有
         1.需要区分两个变量
         2.在闭包中访问外界属性才需要加上self
         */
        UIView.animateWithDuration(1.5) {
            
            //4.重复动画
            UIView.setAnimationRepeatCount(MAXFLOAT)
            
            self.scanLineCons.constant = self.containerHeightCons.constant
            //3.强制更新
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func photoBtnClick(sender: AnyObject) {
        
        //打开相册
        //1.判断能否能够打开相册
        /**
         case PhotoLibrary 相册
         case Camera 相机
         case SavedPhotosAlbum 图片库 //??可删?
         */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            return
        }
        
        //2.创建相册控制器
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.delegate = self
        
        //3.弹出相册控制器
        presentViewController(imagePickerVc, animated: true, completion: nil)
    }
    
    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 二维码的扫描
    // MARK: - 懒加载
    /**
     输入对象
     */
    private lazy var input: AVCaptureDeviceInput? = {
        
       let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
       return try? AVCaptureDeviceInput(device: device)
        
    }()
    /**
     会话
     */
    private lazy var session: AVCaptureSession = AVCaptureSession()
    /**
     输出对象
     */
//    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    private lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        //设置 输出对象 解析数据时 感兴趣的范围
        //默认值(传入的是比例) : CGRect(x: 0, y: 0, width: 1, height: 1)
        //注意 : 参照 //???
        

        //1.获取屏幕的frame
        let viewRect = self.view.frame
        //2.获取扫描容器的frame
        let containerRect = self.customContainerView.frame
        let x = containerRect.origin.y / viewRect.height
        let y = containerRect.origin.x / viewRect.width
        let width = containerRect.height / viewRect.height
        let height = containerRect.width / viewRect.width
        
        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        
        return out
    }()
    
    /**
     预览图层
     */
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    //专门用于保存描边的图层
    private lazy var containerLayer: CALayer = CALayer()

}

/**
 注意 : 这俩个代理的顺序错了会报错
 UIImagePickerControllerDelegate, UINavigationControllerDelegate
 */
extension QRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //选中图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        ZYLog(info)
        
        //1.取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            return
        }
        
        guard let ciImage = CIImage(image: image) else
        {
            return
        }
        
        //2.从选中的图片中读取二维码数据
        //2.1创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        
        //2.2利用探测器探测数据
        let results = detector.featuresInImage(ciImage)
        
        //2.3取出探测到的数据
        for result in results {
            ZYLog((result as! CIQRCodeFeature).messageString)
        }
        
        //注意 : 如果实现了该方法,当选出一张图片时,系统就不会自动关闭相册控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate
{
    /**
     只要扫描到结果就会调用
     */
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        //1.显示结果
        customLabel.text = metadataObjects.last?.stringValue
        
        clearLayers()
        
        //2.拿到扫描到的数据
        guard let metadata = metadataObjects.last as? AVMetadataObject else{
            return
        }
        
        //转换前 : corners { 0.3,0.7 0.5,0.7 0.5,0.4 0.3,0.4 }
        // 转换后: corners { 40.0,230.3 30.9,403.9 216.5,416.3 227.1,244.2 }
        //通过预览图层将corners值转化为我们能识别的类型
        let objc = previewLayer.transformedMetadataObjectForMetadataObject(metadata)

//        ZYLog((objc as! AVMetadataMachineReadableCodeObject).corners)
        
        //3.对扫描到的二维码进行描边
        drawLines(objc as! AVMetadataMachineReadableCodeObject)
    }
    /**
     绘制描边
     */
    private func drawLines(objc: AVMetadataMachineReadableCodeObject)
    {
        //0.安全检验
        guard let array = objc.corners else{
            return
        }
        
        //1.创建图层,用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        //边框的颜色
        layer.strokeColor = UIColor.greenColor().CGColor
        //矩形 内部 的填充颜色
        layer.fillColor = UIColor.clearColor().CGColor
        
        //2.创建UIBezierPath,绘制矩形
        let path = UIBezierPath()
        var point = CGPointZero
        var index = 0
        
        //将字典转换为点//??
        CGPointMakeWithDictionaryRepresentation((array[index++] as! CFDictionary), &point)
        
        //2.1将起点移动到某一个点
        path.moveToPoint(point)
        
        //2.2连接其他线段
        while index < array.count {
            CGPointMakeWithDictionaryRepresentation((array[index++] as! CFDictionary), &point)
            path.addLineToPoint(point)
        }
        
        //2.3关闭路径
        path.closePath()
        layer.path = path.CGPath
        
        //3.将 用于保存矩形的图层 添加到 界面上
        containerLayer.addSublayer(layer)
        
    }
    /**
     清空描边
     */
    private func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
}

extension QRCodeViewController: UITabBarDelegate
{
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        //根据当前选中的按钮重新设置二维码容器的高度
        containerHeightCons.constant = (item.tag == 1) ? 150 : 300
        
        //强制刷新
        view.layoutIfNeeded()
        
        //移除动画
        scanLineView.layer.removeAllAnimations()
        
        //重新开启动画
        startAnimation()
    }
}
