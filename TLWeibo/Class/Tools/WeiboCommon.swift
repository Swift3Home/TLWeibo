//
//  WeiboCommon.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/19.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import Foundation

// MARK: - 应用程序信息

// 应用程序 ID
let TLAppKey = "171530464"
// 应用程序加密信息(开发者可以申请修改)
let TLAppSecret = "74b2c7c5ce4cbc4d0e754b67a0ee5973"
// 回调地址 - 登录完成调转的 URL,参数以 get 形式拼接
let TLRedirectUri = "http://baidu.com"


// MARK: - 全局通知定义

// 用户需要登录通知
let TLUserShouldLoginNotification = "TLUserShouldLoginNotification"

// 用户登录成功通知
let TLUserLoginSuccessNotification = "TLUserLoginSuccessNotification"

