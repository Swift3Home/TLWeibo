//
//  UIView+TLAddition.m
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UIView+TLAddition.h"

@implementation UIView (TLAddition)

- (UIImage *)tl_snapshotImage {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end
