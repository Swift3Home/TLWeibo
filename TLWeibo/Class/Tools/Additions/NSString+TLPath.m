//
//  NSString+TLPath.m
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "NSString+TLPath.h"

@implementation NSString (TLPath)

- (NSString *)tl_appendDocumentDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)tl_appendCacheDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)tl_appendTempDir {
    NSString *dir = NSTemporaryDirectory();
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

@end
