//
//  Bundle+Extensions.swift
//  TLReflection
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import Foundation

extension Bundle {
    
    // 返回命名空间字符串
//    func namespace() -> String {
//        
//        // return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
//        return infoDictionary?["CFBundleName"] as? String ?? ""
//    }
    
    // 计算型属性类似于函数，没有参数，有返回值
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
