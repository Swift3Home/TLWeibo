//
//  UIBarButtonItem+Extension.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/10.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    
    /// 创建UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize, 默认 16 号
    ///   - target: target
    ///   - action: action
    ///   - isBack: 是否是返回按钮，若是，加上箭头
    ///
    /// - returns: UIBarButtonItem
    convenience init(title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false) {
        let buttonItem: UIButton = UIButton.tl_textButton(title, fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isBack {
            let imageName = "navigationbar_back_withtext"
            buttonItem.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            buttonItem.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            
            buttonItem.sizeToFit()
        }
    
        buttonItem.addTarget(target, action: action, for: .touchUpInside)
        
        // self.init 实例化 UIBarButtonItem
        self.init(customView: buttonItem)
    }
}
