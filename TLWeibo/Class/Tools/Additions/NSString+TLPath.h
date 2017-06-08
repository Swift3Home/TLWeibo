//
//  NSString+TLPath.h
//
//  Created by lichuanjun on 2017/6/8.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TLPath)

/// 给当前文件追加文档路径
- (NSString *)tl_appendDocumentDir;

/// 给当前文件追加缓存路径
- (NSString *)tl_appendCacheDir;

/// 给当前文件追加临时路径
- (NSString *)tl_appendTempDir;

@end
