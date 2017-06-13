//
//  TLTestViewController.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/10.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit

class TLTestViewController: TLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        title = "第 \(navigationController?.childViewControllers.count ?? 0) 个"
    }
    
    // MARK: - 监听方法
    // 继续 push 一个新的控制器
    @objc fileprivate func showNext() {
        
        let vc = TLTestViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TLTestViewController {
    
    // 重写父类的方法
    override func setupTableView() {
        // 设置右侧的控制器
        // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(showNext))
        
        //        let rightButtonItem: UIButton = UIButton.tl_textButton("下一个", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        //        rightButtonItem.addTarget(self, action: #selector(showNext), for: .touchUpInside)
        //
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButtonItem)
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}
