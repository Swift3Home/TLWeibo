//
//  TLOAuthViewController.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/19.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 通过webview加载新浪微博授权页面控制器
class TLOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.white
        
        // 取消滚动视图 - 新浪微博的服务器，返回的授权页面默认就是手机全屏
        webView.scrollView.isScrollEnabled = false
        // 设置代理
        webView.delegate = self
        
        // 设置导航栏
        title = "登录新浪微博"
        // 导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", fontSize: 16, target: self, action: #selector(close), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(TLAppKey)&redirect_uri=\(TLRedirectUri)"
        
        // 1> URL 确定要访问的资源
        guard let url = URL(string: urlString) else {
            return
        }
        
        // 2> 建立请求
        let request = URLRequest(url: url)
        
        // 3> 加载请求
        webView.loadRequest(request)
        
    }


    // MARK: - 监听方法
    @objc fileprivate func close() {
        SVProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
    }
    
    // 自动填充 - webView 的注入，直接通过 js 修改 `本地浏览器中` 缓存的页面内容；
    // 点击登录按钮，执行 submit() 将本地数据提交给服务器
    @objc private func autoFill() {
        
        // 准备js
        let js = "document.getElementById('userId').value = 'lichuanjun56@sina.com';" + "document.getElementById('passwd').value = '';"
        
        // webview 执行 js
        webView.stringByEvaluatingJavaScript(from: js)
        
    }
}

extension TLOAuthViewController: UIWebViewDelegate {
    
    
    /// webView 将要加载请求
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: 要加载的请求
    ///   - navigationType: 导航类型
    /// - Returns: 是否加载 request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 确认思路：
        // 1.如果请求地址包含：http://baidu.com 不加载页面 / 否则加载页面
        // request.url?.absoluteString.hasPrefix(TLRedirectUri) 返回的是可选项 true/false/nil
        if request.url?.absoluteString.hasPrefix(TLRedirectUri) == false {
            return true
        }
//        print("加载请求 --- \(request.url?.absoluteString)")
//        print("加载请求 --- \(request.url?.query)")
        
        // 2.从 http://baidu.com 回调地址的`查询字符串`中查找`code=`
        //   如果有，授权成功，否则授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            
            return false
        }
        
        // 3. 从 query 字符串中取出 授权码
        // 代码走到此处，url 中一定有 查询字符串，并且包含 `code=`
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("授权码 - \(code)")
        
        // 4. 使用授权码 获取[换取] AccessToken
        TLNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
                // 发送通知来跳转界面
                // 1> 发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TLUserLoginSuccessNotification), object: nil)
                
                // 2> 关闭窗口
                self.close()
            }
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
