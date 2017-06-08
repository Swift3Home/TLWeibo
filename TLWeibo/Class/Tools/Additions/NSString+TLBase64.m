//
//  NSString+TLBase64.m
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "NSString+TLBase64.h"

@implementation NSString (TLBase64)

- (NSString *)tl_base64Encode {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)tl_base64Decode {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
