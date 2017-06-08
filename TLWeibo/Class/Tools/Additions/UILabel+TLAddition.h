//
//  UILabel+TLAddition.h
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TLAddition)

/// 创建文本标签
///
/// @param text     文本
/// @param fontSize 字体大小
/// @param color    颜色
///
/// @return UILabel
+ (instancetype)tl_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

@end
