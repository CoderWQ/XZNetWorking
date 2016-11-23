//
//  XZCacheManager.m
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZCacheManager.h"

@implementation XZCacheManager

+ (instancetype)shareManager{
    
    static XZCacheManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[XZCacheManager alloc]init];
    });
    return mgr;
}

@end
