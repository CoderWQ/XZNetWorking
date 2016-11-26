//
//  XZCacheDefine.h
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//
#ifdef DEBUG
#define XZLOG(...) NSLog(__VA_ARGS__)
#define XZLOG_CURRENT_METHOD NSLog(@"%@-%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#define XZLOG(...) ;
#define XZLOG_CURRENT_METHOD ;
#endif

#import <Foundation/Foundation.h>

#define XZFileManager [NSFileManager defaultManager]
#define XZUserDefaults [NSUserDefaults standardUserDefaults]

#define XZCustomCacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"XZNetworking"] stringByAppendingPathComponent:@"networkCache"]
