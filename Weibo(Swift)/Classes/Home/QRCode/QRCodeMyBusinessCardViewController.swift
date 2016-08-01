//
//  QRCodeMyBusinessCardViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/8/1.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit

class QRCodeMyBusinessCardViewController: UIViewController {

    /**
     二维码容器
     */
    @IBOutlet weak var customImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //生成二维码
        generateQRCode()
    }

    /**
     生成二维码
     */
    func generateQRCode()
    {
        //1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //2.还原滤镜默认属性
        filter?.setDefaults()
        
        //3.设置需要生成二维码的数据到滤镜中
        //OC中,要求设置的是一个 二进制数据
        filter?.setValue("zhouyuan".dataUsingEncoding(NSUTF8StringEncoding), forKeyPath: "InputMessage")//InputMessage固定
        
        //4.从滤镜中取出,是一个模糊图片,生成高清二维码图片
        guard let ciImage = filter?.outputImage else{
            return
        }
        
//        customImageView.image = UIImage(CIImage: ciImage)
        customImageView.image = createNonInterpolatedUIImageFormCIImage(ciImage, size: 500)//??300
    }
    
    /**
     生成高清二维码
     image : 需要生成的原始图片
     size  : 生成二维码的宽高
     //polated插入\Inter插入
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage,size: CGFloat) -> UIImage
    {
        let extent: CGRect = CGRectIntegral(image.extent)//Integral积分的;完整的;必须的//extent程度;长度;广大地域;扣押
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        //1.创建bitmap
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef, CGInterpolationQuality.None)//Interpolation窜改;添写，插补
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        
        //2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }

}
