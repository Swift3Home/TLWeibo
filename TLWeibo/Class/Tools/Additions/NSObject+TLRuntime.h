//
//  NSObject+TLRuntime.h
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TLRuntime)

/// 使用字典数组创建当前类对象的数组
///
/// @param array 字典数组
///
/// @return 当前类对象的数组
+ (NSArray *)tl_objectsWithArray:(NSArray *)array;

/// 返回当前类的属性数组
///
/// @return 属性数组
+ (NSArray *)tl_propertiesList;

/// 返回当前类的成员变量数组
///
/// @return 成员变量数组
+ (NSArray *)tl_ivarsList;

@end
