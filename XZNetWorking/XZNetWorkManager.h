//
//  XZNetWorkingManager.h
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZNetWorkingDefine.h"

#define XZDefaultRefresh YES
#define XZDefaultCache YES
#define XZDefaultGraceTimeType XZNetworkRequestGraceTimeTypeNone

@interface XZNetWorkManager : NSObject


@property(nonatomic,strong)XZNetworkItem *item;
/**
 多次请求同一接口，YES为只保留最新一次请求。No为保存第一次请求。
 */
@property (nonatomic,assign)BOOL refresh;

/**
 是否需要缓存。 YES为需要   NO为不需要
 */
@property (nonatomic,assign)BOOL haveCache;


/**
 HUD枚举--显示的情况
 */
@property (nonatomic,assign)XZNetworkRequestGraceTimeType graceTimeType;

//******************配置参数******************//

+ (instancetype)manager;


/**
 *  配置请求头(非必填)
 *
 *  @param httpHeader 请求头
 */
+ (void)configHttpHeader:(NSDictionary *)httpHeader;

/**
 *	设置超时时间
 *
 *  @param timeout 超时时间
 */
+ (void)setupTimeout:(NSTimeInterval)timeout;




/**
 普通的GET请求

 @param URLString 网址
 @param parameters 参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)GETRequestWithUrl:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                  success:(XZRequestSuccessBlock)successBlock
                  failure:(XZRequestFailureBlock)failureBlock;

/**
 不普通的GET请求

 @param URLString 网址
 @param parameters 参数
 @param refresh YES保留最新一次请求 NO保留旧的请求
 @param cache 是否需要缓存
 @param successBlock 成功的回调
 @param failureBlock 失败的回调
 */
- (void)GETRequestWithUrl:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                  refresh:(BOOL)refresh
                    cache:(BOOL)cache
                graceTime:(XZNetworkRequestGraceTimeType)graceTime
                  success:(XZRequestSuccessBlock)successBlock
                  failure:(XZRequestFailureBlock)failureBlock;




// 一次性设置是否需要一次刷新操作 ，以及设置是否需要cache,以及显示指示框
- (void)setupRefresh:(BOOL)refresh HaveCache:(BOOL)haveCache showHud:(XZNetworkRequestGraceTimeType)graceTimeType;










#pragma mark - 取消相关请求
/**
 *  取消GET请求
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 取消所有的请求
 */
+ (void)cancelAllRequest;

 





@end
