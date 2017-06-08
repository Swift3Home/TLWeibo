//
//  UILabel+TLAddition.m
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UILabel+TLAddition.h"

@implementation UILabel (TLAddition)

+ (instancetype)tl_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *label = [[self alloc] init];
    
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.numberOfLines = 0;
    
    [label sizeToFit];
    
    return label;
}

@end
