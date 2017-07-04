//
//  TLNetworkManager.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/14.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit
import AFNetworking

// Swift 的枚举类型支持任意数据类型
// switch / enum 在 OC 中都只能支持整形
enum TLHTTPMethod {
    case GET
    case POST
}

// 网络管理工具
class TLNetworkManager: AFHTTPSessionManager {

    // 单例（静态区 常量 闭包）
    static let shared: TLNetworkManager = {
        
        // 实例化对象
        let instance = TLNetworkManager()
        
        // 设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        // 返回对象
        return instance
    }()
    
    // 用户账户的懒加载属性
    lazy var userAccount = TLUserAccount()
    
    // 用户登录标记[计算型属性]
    var userLogon : Bool {
        return userAccount.access_token != nil
    }
    
    
    // 专门负责拼接 token 的网络请求方法
    func tokenRequest(method: TLHTTPMethod = .GET,  URLString: String, parameters: [String: Any]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        // 处理 token 字典
        // 1> 判断 token 是否为nil，为 nil 直接返回
        guard let token = userAccount.access_token else {
            
            // 发送通知，提示登录
            print("没有 token 需要登录")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: TLUserShouldLoginNotification), object: nil)
            
            completion(nil, false)
            return
        }
        // 2> 判断 参数字典是否存在，如果为nil，应该新建一个字典
        var parameters = parameters
        if parameters == nil {
            // 实例化字典
            parameters = [String: Any]()
        }
        
        // 3> 设置参数字典，代码在此处字典一定有值
        parameters!["access_token"] = token
        
        // 调用 request 发起真正的网络请求方法
        request(URLString: URLString, parameters: parameters!, completion: completion)
    }
    
    
    /// 封装 AFN 的 GET /POST 请求
    ///
    /// - Parameters:
    ///   - method: GET / POST
    ///   - URLString: URLString
    ///   - parameters: 参数字典
    ///   - completion: 完成回调[json(字典/数组)，是否成功]
    func request(method: TLHTTPMethod = .GET,  URLString: String, parameters: [String: Any], completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        // 成功回调
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            completion(json as AnyObject, true)
        }
        // 失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            
            // 针对 403 处理用户 token 过期
            // 对于测试用户(应用程序还没有提交给新浪微博审核)每天的刷新了是有限的
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期")
                
                // 发送通知(本方法不知道被谁处理，谁接收到通知，谁处理)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TLUserShouldLoginNotification), object: "bad token")
            }
            
            print("网络请求错误 \(error)")
            
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }

        
    }
}
