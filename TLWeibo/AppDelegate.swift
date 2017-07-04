//
//  AppDelegate.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 应用程序额外设置
        setupAdditions()
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = TLMainViewController()
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
        return true
    }

}

// MARK: - 设置应用程序额外信息
extension AppDelegate {
    
    fileprivate func setupAdditions() {
        
        // 1. 设置 SVProgressHUD 最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
        // 2. 设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        // 3. 设置用户授权显示通知
        // #available 检测设备版本 10.0以上
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (success, error) in
                
                print("授权" + (success ? "成功" : "失败"))
                
            }
        } else {
            // Fallback on earlier versions
            // 获得用户授权显示通知(上方的提示条/声音/BadgeNumber) 10.0以下
            let nitifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(nitifySettings)
        }
    }
    
}


// MARK: - 从服务器加载应用程序信息
extension AppDelegate {
    
    fileprivate func loadAppInfo() {
        
        // 1. 模拟异步
        DispatchQueue.global().async {
            
            // 1> url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            // 2> data
            let data = NSData(contentsOf: url!)
            
            // 3> 写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕 \(jsonPath)")
        }
        
    }
}
