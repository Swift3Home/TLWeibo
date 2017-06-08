//
//  NSString+TLBase64.h
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TLBase64)

/// 对当前字符串进行 BASE 64 编码，并且返回结果
- (NSString *)tl_base64Encode;

/// 对当前字符串进行 BASE 64 解码，并且返回结果
- (NSString *)tl_base64Decode;

@end
