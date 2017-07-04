//
//  TLTitleButton.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit

class TLTitleButton: UIButton {

    // 重载构造函数
    /*
     title  如果是nil，就显示首页
            如果不为nil，显示 title 和 箭头图像
     */
    init(title: String?) {
        super.init(frame: CGRect())
        
        // 1> 判断 title 是否为 nil
        if title == nil {
            setTitle("首页", for: [])
        } else {
            setTitle(title! + " ", for: [])
            
            // 设置图像
            setImage(UIImage(named: "navigationbar_arrow_down"), for: [])
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        // 2> 设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
        
        // 3> 设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重新布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let titleLabel = titleLabel,
            let imageView = imageView else {
            return
        }

//        // 将 label 的 x 坐标向左移动 imageView 的宽度
        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)

//        // 将 imageView 的 x 坐标向右移动 label 的宽度
        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
    }
}


