//
//  TLVisitorView.swift
//  TLWeibo
//
//  Created by lichuanjun on 2017/6/11.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

import UIKit

// 访客视图
class TLVisitorView: UIView {

    // 注册按钮
    lazy var registerButton: UIButton = UIButton.tl_textButton(
        "注册",
        fontSize: 16,
        normalColor: UIColor.orange,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    
    // 登录按钮
    lazy var loginButton: UIButton = UIButton.tl_textButton(
        "登录",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightedColor: UIColor.black,
        backgroundImageName: "common_button_white_disable")
    
    // 访客视图的信息字典 [imageName / message]
    // 如果是首页 imageName == ""
    var visitorInfo: [String: String]? {
        didSet {
            // 1> 取字典信息
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            
            // 2> 设置消息
            tipLabel.text = message
            
            // 3> 设置图像，首页不需要设置
            if imageName == "" {
                startAnimation()
                
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            // 其他控制器的访客视图不需要显示小房子/遮罩视图
            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("'required' initializer 'init(coder:)' must be provided by subclass of 'UIView'")
    }
    
    // 选择图标动画
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT//不停的旋转
        anim.duration = 15//旋转一圈的时间
        
        // 动画完成不删除，如果 iconView 被释放，动画会一起销毁
        anim.isRemovedOnCompletion = false
        
        // 将动画添加到图层
        iconView.layer.add(anim, forKey: nil)
    }
    
    // MARK: - 私有控件
    // 懒加载属性只有调用 UIKit 控件的指定构造函数，其他都需要使用类型
    // 图像视图
    fileprivate lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    // 遮罩视图
    fileprivate lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    // 小房子
    fileprivate lazy var houseIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    // 提示标签
    fileprivate lazy var tipLabel: UILabel = UILabel.tl_label(
        withText: "关注一些人，回这里看看有什么惊喜；关注一些人，回这里看看有什么惊喜",
        fontSize: 14,
        color: UIColor.darkGray)
}


// MARK: - 设置界面
extension TLVisitorView {
    
    func setupUI() {
        // 0. 在开发的时候，如果能够使用颜色，就不要使用图像，效率更高
        backgroundColor = UIColor.tl_color(withHex: 0xEDEDED)

        // 1.添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 文本居中
        tipLabel.textAlignment = .center
        
        // 2. 纯代码控件布局 (取消autoresizing)
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 3. 自动布局
        let margin: CGFloat = 20
        
        // 1> 图像视图
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        
        // 2> 小房子
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        
        // 3> 提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 236))
        // 4> 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        // 5> 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: registerButton,
                                         attribute: .width,
                                         multiplier: 1.0,
                                         constant: 0))
        
        // 6> 遮罩视图 (VFL)
        // views: 定义 VFL 中的控件名称和实际名称映射关系
        // metrics: 定义 VFL 中 () 指定的常数映射关系
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton] as [String : Any]
        let metrics = ["spacing": -registerButton.bounds.height]

        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDict))
    }
}
