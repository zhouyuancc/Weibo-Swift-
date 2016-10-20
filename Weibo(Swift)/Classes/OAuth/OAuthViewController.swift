//
//  OAuthViewController.swift
//  Weibo(Swift)
//
//  Created by ZhouYuan on 16/8/15.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    /**
     网页容器
     */
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.定义字符串保存登录界面URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)"
        
        //2.创建URL
        guard let url = NSURL(string: urlStr) else
        {
            return
        }
        
        //3.创建Request
        let request = NSURLRequest(URL: url)
        
        //4.加载登陆界面
        customWebView.loadRequest(request)
    }
    
    // MARK: - 内部控制方法
    @IBAction func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func autoBtnClick() {
        
        let jsStr = "document.getElementById('userId').value = 'kamui-c@163.com';" +
        "document.getElementById('passwd').value = '';"
        //webView调用js
        customWebView.stringByEvaluatingJavaScriptFromString(jsStr)
    }

}

extension OAuthViewController: UIWebViewDelegate
{
    func webViewDidStartLoad(webView: UIWebView) {
        
        //显示提醒
        SVProgressHUD.showInfoWithStatus("正在加载中...", maskType: SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        //关闭提醒
        SVProgressHUD.dismiss()
    }
    
    
    //该方法每次请求都会调用
    //返回false : 不允许请求;true : 允许请求
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        /**
         如果授权回调页面包含code=代表授权成功
         如果是授权回调页面不需要显示给用户看,返回false
         */
        //1.判断当前是否是授权回调页面
        guard let urlStr = request.URL?.absoluteString else{
            
            ZYLog(request.URL?.absoluteString)
            
            return false
        }
        
        ZYLog(urlStr)//https://api.weibo.com/oauth2/authorize?client_id=965411328&redirect_uri=http://www.baidu.com
        //http://www.baidu.com/?code=ceff0fd80c4a24e9cf7760bdaf3d12c0
        
        if !urlStr.hasPrefix(WB_Redirect_uri) {
            ZYLog("不是授权回调页面")
            return true
        }
        
        ZYLog("是授权回调页面")
        //2.判断授权回调地址中是否包含code=
        //URL的query属性是专门用于获取URL中的参数的,可以获取URL中?后面的所有内容
        let key = "code="
        guard let str = request.URL!.query else
        {
            return false
        }
        
        if str.hasPrefix(key)
        {
            let code = str.substringFromIndex(key.endIndex)
            loadAccessToken(code)
            return false
        }
        
        ZYLog("授权失败")
        return false
    }
    
    /**
     利用RequestToken换取AccessToken
     */
    private func loadAccessToken(codeStr: String?)
    {
        guard let code = codeStr else{
            return
        }
        
        //注意 : redirect_uri必须和开发中平台中填写的一模一样
        //1.准备请求路径
        let path = "oauth2/access_token"
        //2.准备请求参数
        let parameters = ["client_id": WB_App_Key,"client_secret":WB_App_Secret,"grant_type":"authorization_code","code": code,"redirect_uri":WB_Redirect_uri]
        //3.发送POST请求
        NetworkTools.shareInstance.POST(path, parameters: parameters, success: { (task: NSURLSessionDataTask, objc: AnyObject?) in
            
            ZYLog(objc)
            //1.将授权信息转换为模型
            let account = UserAccount(dict: objc as! [String : AnyObject])
            
            //2.获取用户信息
            account.loadUserInfo({ (account, error) in
                //3.保存用户信息
                account?.saveAccount()
                
                //4.跳转到欢迎界面
                /*
                let sb = UIStoryboard(name: "Welcome", bundle: nil)
                let vc = sb.instantiateInitialViewController()!

                UIApplication.sharedApplication().keyWindow?.rootViewController = vc
                */
                
                NSNotificationCenter.defaultCenter().postNotificationName(ZYSwitchRootViewController, object: false)
                
                //关闭界面
                self.closeBtnClick()
            })
            
            ZYLog(account.saveAccount())
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                
                ZYLog(error)
        }
        
    }
    
}
