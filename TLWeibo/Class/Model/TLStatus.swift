//
//  TLStatus.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/16.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit
import YYModel

/// 微博数据模型
class TLStatus: NSObject {

    // 每条微博的ID
    var id: Int64 = 0
    // 微博的新闻内容
    var text: String?
    
    // 重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
}
