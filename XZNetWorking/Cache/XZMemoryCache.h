//
//  XZMemoryCache.h
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZMemoryCache : NSObject

/**
 *  将数据写入内存
 *
 *  @param data 数据
 *  @param key  键值
 */
+ (void)writeData:(id)data forkey:(NSString *)key;

/**
 *  从内存中读取数据
 *
 *  @param key 键值
 *
 *  @return 数据
 */
+ (id)readDataByKey:(NSString *)key;
@end
