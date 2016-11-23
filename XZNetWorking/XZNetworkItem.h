//
//  XZNetworkItem.h
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZNetWorkingDefine.h"

@interface XZNetworkItem : NSObject

@property(nonatomic,weak)id<XZNetWorkDelegate> delegate;

@property (nonatomic,assign)RequestType requsetType;

@property (nonatomic,strong)NSString *urlString;

@property (nonatomic,strong)NSDictionary *params;


@property (nonatomic,copy)XZDownloadProgress progress;

@property (nonatomic,copy)XZRequestSuccessBlock success;

@property (nonatomic,copy)XZRequestFailureBlock failure;

@property (nonatomic,assign,getter=isRefresh)BOOL refresh;

@property (nonatomic,assign,getter=isHaveCache)BOOL haveCache;


@property (nonatomic,strong)NSMutableArray *allTasks;

/**
 初始化一些参数
 
 @param requestType .GET .POST
 @param url 网址类型
 @param Cache 是否要缓存
 @param refresh 是否只存在一个请求（多次发起同一请求，会取消前一个请求）
 @param params 请求参数
 @param success 成功
 @param failure 失败
 @return 自己，感谢。
 */
- (XZNetworkItem *)initWithRequetType:(RequestType)requestType
                                  Url:(NSString *)url
                                cache:(BOOL)cache
                       refreshRequest:(BOOL)refresh
                               params:(NSDictionary *)params
                             progress:(XZDownloadProgress)progress
                              success:(XZRequestSuccessBlock)success
                              failure:(XZRequestFailureBlock)failure;



- (XZNetworkItem *)initWithRequetType:(RequestType)requestType
                                  Url:(NSString *)url
                               params:(NSDictionary *)params
                              success:(XZRequestSuccessBlock)success
                              failure:(XZRequestFailureBlock)failure;




@end
