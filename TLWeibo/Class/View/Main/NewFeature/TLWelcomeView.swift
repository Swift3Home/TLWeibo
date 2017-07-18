//
//  TLWelcomeView.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/30.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit
import SDWebImage

/// 欢迎视图
class TLWelcomeView: UIView {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    // 图标宽度约束
    @IBOutlet weak var iconWidthCons: NSLayoutConstraint!
    
    class func welcomeView() -> TLWelcomeView {
        
        let nib = UINib(nibName: "TLWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! TLWelcomeView
        
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 提示：initWithCoder 只是刚刚从 XIB 的二进制文件将试图数据加载完成
        // 还没有和代码连线建立起关系，所以开发时，千万不要在这个方法中处理UI
        print("initWithCoder + \(iconView)")
    }
    
    // 从 XIB 加载完成调用
    override func awakeFromNib() {
        
        // 1. url
        guard let urlString = TLNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlString) else {
                return;
        }
        
        // 2. 设置头像
        iconView.sd_setImage(with: url,
                             placeholderImage: UIImage(named: "avatar_default_big"))
        
        // 3. FIXME: - 设置圆角(iconView的 bounds 还没有设置)
        iconView.layer.cornerRadius = iconWidthCons.constant * 0.5
        iconView.layer.masksToBounds = true
    }
    
    
    /// 视图被添加到 window 上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 视图是使用自动布局来设置的，只是设置了约束
        // - 当视图被添加到窗口上时，更加父视图的大小，计算约束值，更新控件位置
        // - layoutIfNeeded 会直接按照当前的约束直接更新控件位置
        // - 执行之后，控件所在位置，就是 XIB 中布局的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        // 如果所有控件的 frame 还没有计算好，所有的约束会一起动画
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        //更新约束
                        self.layoutIfNeeded()
         }) { (_) in
            
            UIView.animate(withDuration: 1.0,
                           animations: { 
                            self.tipLabel.alpha = 1
            }, completion: { (_) in
                self.removeFromSuperview()
            })
            
        }
    }
}
