//
//  XZMemoryCache.m
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZMemoryCache.h"
#import <UIKit/UIKit.h>
@implementation XZMemoryCache

+ (NSCache *)shareCache{
    
    static NSCache *shareCache;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCache = [[NSCache alloc] init];
    });
    
    // 注册内存警告的通知
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [shareCache removeAllObjects];
    }];
    
    return shareCache;
    
    
    
    
}

+ (void)writeData:(id __nonnull) data forKey:(NSString * __nonnull)key{
    
    assert(data);
    
    assert(key);
    
    NSCache *cache = [XZMemoryCache shareCache];
    
    [cache setObject:data forKey:key];
    
}

+ (id)readDataByKey:(NSString *)key{
    
    assert(key);
    
    NSCache *cache = [XZMemoryCache shareCache];
    
    return  [cache objectForKey:key];
    
}

 

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

@end
