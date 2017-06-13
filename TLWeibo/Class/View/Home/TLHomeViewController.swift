//
//  TLHomeViewController.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit

// 定义全局变量，尽量使用 private 修饰，否则到处都可以访问
private let cellId = "cellId"

class TLHomeViewController: TLBaseViewController {

    // 微博数据数组
    fileprivate lazy var statusList = [String]()
    
    // 加载数据
    override func loadData() {
        
        print("开始加载数据")
        
        // 模拟`延迟`加载数据 -> Swift 2.0：dispatch_after
        //                    Swift 3.0：asyncAfter
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            for i in 0..<15 {
                if self.isPullup {
                    // 将数据追加到底部
                    self.statusList.append("上拉 \(i)")
                }
                else {
                    // 将数据插入到数组的顶部
                    self.statusList.insert(i.description, at: 0)
                }
            }
            
            print("加载数据结束")
            
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            // 恢复上拉刷新标记
            self.isPullup = false
            
            // 刷新表格
            self.tableView?.reloadData()
        }
        
    }
    
    @objc fileprivate func showFriends() {
        print(#function)
        
        let vcTest = TLTestViewController()
        
        // push 的动作是 nav 做的
        navigationController?.pushViewController(vcTest, animated: true)
    }
}

// MARK: - 表格数据源方法
extension TLHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1. 取 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // 2. 设置 cell
        cell.textLabel?.text = statusList[indexPath.row]
        
        // 3. 返回 cell
        return cell
    }
    
}


// MARK: - 设置界面
extension TLHomeViewController {
    
    // 重写父类的方法
    override func setupTableView() {
        super.setupTableView()
        
        // 设置导航栏按钮(无法高亮)
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        
        // Swift 调用 OC 返回 instanceType 的方法，判断不出是否可选
//        let leftButtonItem: UIButton = UIButton.tl_textButton("好友", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
//        leftButtonItem.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButtonItem)
        
        // 设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))

        
        // 注册原型cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}
