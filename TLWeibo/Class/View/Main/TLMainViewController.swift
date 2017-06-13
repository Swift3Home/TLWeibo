//
//  TLMainViewController.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit

// 主控制器
class TLMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 'setupChildControllers' is inaccessible due to 'private' protection level
        setupChildControllers()
        setupComposeButton()
    }
    
    /**
        portrait    : 竖屏，肖像
        landscape   : 横屏，风景画
     
        - 使用代码控制设备的方向，好处：可以在需要横屏时，单独处理
        - 设置支持的方向之后，当前控制器及子控制器都会遵守该方向
        - 如果播放视频，通常是通过 model 展现的
     
     Swift 3.0 中设置去掉了之前版本中设置当前控制器支持的旋转方向的方法：
     func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    // MARK: - 监听方法
    // 撰写微博
    // @objc 允许这个函数在`运行时`通过 OC 的消息机制被调用
    @objc fileprivate func composeStatus() {
        print("撰写微博")
        
        // 测试方向旋转
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.tl_random()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    
    // MARK: - 私有控件
    // 撰写按钮
    fileprivate lazy var composeButton: UIButton = UIButton.tl_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
}

/*
 extension 类似于 OC 中的分类，在 Swift 中可以用来切分代码块
 可以把相似功能的函数，放在一个 extension 中
 注意：和 OC 的分类一样，extension 中不能定义属性
*/
// MARK: - 设置界面
extension TLMainViewController {
    
    // 设置撰写按钮
    fileprivate func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        // 计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        let width = tabBar.bounds.width / count - 1// 将向内缩进的宽度减少，能够让按钮的宽度变大，盖住容错点，防止穿帮
        
        // OC 中有方法： CGRectInset 正数向内缩进，负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        print("撰写按钮\(composeButton.bounds.width)")
        
        // 按钮监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    // 设置所有子控制器
    fileprivate func setupChildControllers() {
        
        // 0. 获取沙盒 json 路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        // 加载 data
        var data = NSData(contentsOfFile: jsonPath)
        
        // 判断 data 是否有内容，如果没有，说明本来沙盒没有文件
        if data == nil {
            // 从Bundle 加载 data
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            
            data = NSData(contentsOfFile: path!)
            
        }
        
        // data 一定会有一个内容，反序列化
        
        
        // 从bundle加载配置的json
        // 反序列化转换成数组
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String : Any]] else {
            return
        }
        
        // 遍历数组，循环创建控制器数组
        var arrayAll = [UIViewController]()
        for dict in array! {
            arrayAll.append(controller(dict: dict))
        }
        
        // 设置 tabBar 的子控制器
        viewControllers = arrayAll
    }
    
    
    /// 使用字典创建一个子控制器path
    ///
    /// - Parameter dict: 信息字典[clsName, title, imageName, visitorInfo]
    /// - Returns: 子控制器
    private func controller(dict: [String: Any]) -> UIViewController {
        
        // 1. 取得字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? TLBaseViewController.Type,
        let visitorDict = dict["visitorInfo"] as? [String: String] else {
                return UIViewController()
        }
        
        // 2. 创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        // 设置控制器的访客信息字典
        vc.visitorInfoDictionary = visitorDict;
        
        // 3. 设置头像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        // 4. 设置 tabbar 标题字体
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        // 系统默认是 12 号字，修改字体大小，要设置 Normal 的字体大小
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: UIControlState.normal)
        
        // 实例化导航控制器时，会调用 push 方法将 rootViewController 压栈
        let nav = TLNavigationController(rootViewController: vc)
        return nav
    }
}
