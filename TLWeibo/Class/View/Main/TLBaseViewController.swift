//
//  TLBaseViewController.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit

// OC 中不支持多继承，可以使用协议替代之
// Swift 的写法更类似于多继承
// class TLBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
// Swift 中利用 extension 可以把函数安装功能分类管理，便于阅读和维护
// 注意：
// 1. extension 中不能有属性
// 2. extension 中不能重写`父类`本类的方法，重写父类方法，是子类的职责，扩展是对类的

// MARK: - 所有主控制器的基类控制器
class TLBaseViewController: UIViewController {
    
    var visitorInfoDictionary: [String: String]?
    
    // 若用户没有登录，就不会创建之
    var tableView: UITableView?
    // 刷新控件
    var refreshControl: UIRefreshControl?
    // 上拉刷新标记
    var isPullup = false
    
    // 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.tl_screenWidth(), height: 64))
    
    // 自定义导航条目 - 以后设置导航栏内容，统一使用 navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        TLNetworkManager.shared.userLogon ? loadData(): ()
        
        // 注册通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loginSuccess),
            name: NSNotification.Name(rawValue: TLUserLoginSuccessNotification),
            object: nil)
        
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // 重写 title 的 didSet 方法
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }

    
    /// 加载数据 - 具体的实现有子类负责
    func loadData() {
        // 如果子类不实现任何方法，默认关闭刷新控件
        refreshControl?.endRefreshing()
    }
}


// MARK: - 访客视图监听方法
extension TLBaseViewController {
    
    // 登录成功处理
    @objc fileprivate func loginSuccess() {
        
        print("登录成功")
        
        // 登录前 左边是好友，右边是登录
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        // 更新 UI -> 将访客视图替换为表格视图
        // 需要重新设置view：在访问view 的getter 时，如果view == nil，会调用 loadView -> viewDidLoad
        view = nil
        
        // 注销通知 -> 重复执行 viewDidLoad 会再次注册！避免通知被重复注册
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc fileprivate func login() {
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TLUserShouldLoginNotification), object: nil)
    }
    
    @objc fileprivate func register() {
        print("用户注册")
    }
}

// MARK: - 设置界面
extension TLBaseViewController {
    
    fileprivate func setupUI() {
        
        view.backgroundColor = UIColor.white
        
        // 取消自动缩进 - 若隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        TLNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    
    
    // MARK: -  设置表格视图 - 用户登录之后执行
    // 子类重写此方法，因为子类不需要关系用户登录之前的逻辑
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 设置数据源和代理 -> 目的：子类直接实现数据源方法
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // 设置内容缩进
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        // 修改指示器的缩进
        tableView?.scrollIndicatorInsets = (tableView?.contentInset)!
        
        // 设置刷新控件
        // 1.实例化控件
        refreshControl = UIRefreshControl()
        
        // 2.添加到表格视图
        tableView?.addSubview(refreshControl!)
        
        // 3. 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    // MARK: -  设置访客视图
    private func setupVisitorView() {
        
        let visitorView = TLVisitorView(frame: view.bounds)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        // 1. 设置访客视图信息
        visitorView.visitorInfo = visitorInfoDictionary
        
        // 2. 添加访客视图按钮的监听方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        // 3. 设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    // MARK: -  设置导航条
    private func setupNavigationBar() {
        // 添加导航条
        view.addSubview(navigationBar)
        
        // 将 item 设置给 bar
        navigationBar.items = [navItem]
        
        // 设置 navBar 的渲染颜色(整个导航条的背景颜色)
        navigationBar.barTintColor = UIColor.tl_color(withHex: 0xF6F6F6)
        
        // 设置 navBar 的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        
        // 设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension TLBaseViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    // 基类只是准备方法，子类负责具体实现
    // 子类的数据源方法不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 保证没有语法错误
        return UITableViewCell()
    }
    
    // 在显示最后一行的时候，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1. 判断 indexPath 是否是最后一行(indexPath.section(最大) / indexPath.row(最后一行))
        let row = indexPath.row
        let sectionMax = tableView.numberOfSections - 1
        
        if row < 0 || sectionMax < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: sectionMax)
        // 如果是最后一行，同时没有开始上拉刷新
        if row == (count - 1) && !isPullup {
            print("上拉刷新")
            isPullup = true
            
            // 开始刷新
            loadData()
        }
    }
}

