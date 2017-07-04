//
//  TLUserAccount.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/20.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit

private let accountFile: NSString = "useraccount.json"

/// 用户账户信息
class TLUserAccount: NSObject {
    
    /// 访问令牌
    var access_token: String?
    /// 用户代号
    var uid: String?
    /// access_token的生命周期，单位是秒数； 开发中：5年；测试者：3天
    var expires_in: TimeInterval = 0.0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expiresDate: Date?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（大图），180x180像素
    var avatar_large: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        
        // 从磁盘加载保存的文件 -> 字典
        // 1> 加载磁盘文件到二进制数据，如果失败直接返回
        guard let path = accountFile.tl_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else {
                return
        }
        
        // 2> 使用字典设置属性值
        // *** 用户是否登录的关键代码
        yy_modelSet(withJSON: dict ?? [:])
        
        // 3> 判断 token 是否过期
        // 测试过期日期
        //expiresDate = Date(timeIntervalSinceNow: -3600 * 24)
        //print(expiresDate)
        
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
            
            // 清空 token
            access_token = nil
            uid = nil
            
            // 删除账户文件
            try? FileManager.default.removeItem(atPath: path)
        }
    }
    
    /**
     1、偏好设置(小)
     2、沙盒 - 归档/plist/json
     3、数据库(FMDB/CoreData)
     4、钥匙串访问(小/自动加密 - 需要使用框架 SSKeychain)
    */
    func saveAccount() {
        // 1. 模型转字典
        var dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        
        // 需要删除 expires_in 值
        dict.removeValue(forKey: "expires_in")
        
        // 2. 字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
        let filePath = accountFile.tl_appendDocumentDir()
        else {
            return
        }
        
        // 3. 写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功 \(filePath)")
    }
}
