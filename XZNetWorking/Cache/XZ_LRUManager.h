//
//  XZ_LRUManager.h
//  XZNetWorking
//
//  Created by coderXu on 16/11/24.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZCacheDefine.h"


#define XZFileName @"XZFileName"
#define XZDate @"XZDate"
#define XZNowDate [NSDate date]
/**
 *  最近最少使用淘汰算法，创建一个队列，新加的结点添加在队列的尾部；命中缓存时，调整结点的位置，将其放在队列的尾部；要淘汰缓存时，删除队列的头部结点
 */
@interface XZ_LRUManager : NSObject

/**
 *  当前队列的情况
 */
@property (nonatomic, copy, readonly)NSArray *currentQueue;


+ (XZ_LRUManager *)shareManager;

/**
 *  添加新的结点
 *
 *  @param filename 文件名字
 */
- (void)addFileToNode:(NSString *)fileName;

/**
 *  调整结点位置，一般用于命中缓存时
 *
 *  @param filename 文件名字
 */
- (void)refreshIndexOfFileNode:(NSString *)filename;


/**
 删除没用的cache

 @param time 根据时间跟LRU算法来删除
 @return 一个数组
 */
- (NSArray *)removeLRUFileNodeWithCacheTime:(NSTimeInterval)time;
@end
