//
//  UIScreen+TLAddition.m
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UIScreen+TLAddition.h"

@implementation UIScreen (TLAddition)

+ (CGFloat)tl_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)tl_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)tl_scale {
    return [UIScreen mainScreen].scale;
}

@end
