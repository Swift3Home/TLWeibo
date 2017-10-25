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

    // 列表视图模型
    fileprivate lazy var listViewModel = TLStatusListViewModel()
    
    // 加载数据
    override func loadData() {
        
        print("准备刷新，最后一条 \(self.listViewModel.statusList.last?.text ?? "")")
        
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            
            print("加载数据结束")
            
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            // 恢复上拉刷新标记
            self.isPullup = false
            
            // 刷新表格
            
            if shouldRefresh {
                self.tableView?.reloadData()
            }
            
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
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1. 取 cell  --方法一
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        // 1. 取 cell方法二
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellId)
        }
        
        // 2. 设置 cell
        cell?.textLabel?.text = listViewModel.statusList[indexPath.row].text
        
        // 3. 返回 cell
        return cell!
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

        
        // 注册原型cell  -- 方法一
//        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupNavTitle()
    }
    
    /// 设置导航栏标题
    fileprivate func setupNavTitle() {
        
        let title = TLNetworkManager.shared.userAccount.screen_name

        let button = TLTitleButton(title: title)
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
    }
    
    @objc fileprivate func clickTitleButton(btn: UIButton) {
        
        // 设置选择状态
        btn.isSelected = !btn.isSelected
    }
    
}
