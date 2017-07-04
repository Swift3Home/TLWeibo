//
//  TLStatusListViewModel.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/16.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import Foundation


/// 微博数据列表视图模型
/*
 - 如果类需要使用 `KVC` 或者字典模型框架设置对象值，类就需要继承自 NSObject
 - 如果类只是包装一下代码逻辑(写了一下函数)，可以不用任何父类，好处：更加轻量级
 - 提示：如果用 OC 写，一律都继承自 NSObject 即可
 
 使命：负责微博的数据处理
 
 1. 字典转模型
 2. 下拉 / 上拉刷新数据处理
 */

// 上拉刷新最大尝试次数
private let maxPullupTryTime = 3

class TLStatusListViewModel {
    
    /// 微博模型数组懒加载
    lazy var statusList = [TLStatus]()
    
    // 上拉刷新错误次数
    private var pullupErrorTimes = 0
    
    /// 加载微博列表
    ///
    /// - pullup: 是否上拉刷新标记
    /// - completion: 完成回调[网络请求是否成功，是否刷新表格]
    func loadStatus(pullup: Bool = false, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        // 判断是否是上拉刷新，同时坚持刷新错误
        if pullup && pullupErrorTimes > maxPullupTryTime {
            completion(true, false)
            
            return
        }
        
        // since_id 取出数组中第一条微博的 id
        let since_id = pullup ? 0 : (statusList.first?.id ?? 0)
        
        // 上拉刷新，取出数组中第一条微博的 id
        let max_id = !pullup ? 0 : (statusList.last?.id ?? 0)
        
        TLNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            // 1. 字典转模型
            guard let array = NSArray.yy_modelArray(with: TLStatus.self, json: list ?? []) as? [TLStatus] else {
                
                completion(isSuccess, false)
                
                return
            }
            
            print("刷新到 \(array.count) 条数据")
            
            // 2. FIXME: 拼接数据
            // 下拉刷新，应该将结果数组拼接在数组前面
            if pullup {
                // 上拉刷新结束后，将结果拼接在数组的末尾
                self.statusList += array
            } else {
                // 下拉刷新，应该将结果数组拼接在数组前面
                self.statusList = array + self.statusList
            }
            
            // 3. 判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                
                completion(isSuccess, false)
            } else {
                // 4.完成回调
                completion(isSuccess, true)
            }
            
        }
    }
}
