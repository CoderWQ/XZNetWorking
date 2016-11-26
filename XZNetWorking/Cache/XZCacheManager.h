//
//  XZCacheManager.h
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZCacheDefine.h"


@interface XZCacheManager : NSObject

+ (instancetype)shareManager;


/**
 *  设置缓存时间和缓存的磁盘空间
 *
 *  @param time     缓存时间
 *  @param capacity 磁盘空间
 */
- (void)setCacheTime:(NSTimeInterval) time diskCapacity:(NSUInteger) capacity;


/**
 存储相应数据

 @param responseObject 内容
 @param requestUrl 网址
 @param params 参数
 */
- (void)saveCacheResponseObject:(id)responseObject
                 requestUrl:(NSString *)requestUrl
                     params:(NSDictionary *)params;

/**
 *  获取响应数据
 *
 *  @param requestUrl 请求url
 *  @param params     请求参数
 *
 *  @return 响应数据
 */
- (id)getCacheResponseObjectWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params;

/**
 *  清除最近最少使用的缓存，用LRU算法实现
 */
- (void)clearLRUCache;



@end
