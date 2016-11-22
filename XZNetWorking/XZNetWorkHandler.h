//
//  XZNetWorkHandler.h
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZNetWorkingDefine.h"
#import "XZNetworkItem.h"

@interface XZNetWorkHandler : NSObject<XZNetWorkDelegate>

@property(nonatomic,strong)XZNetworkItem *item;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,assign,getter=isNetWorkError)BOOL NetWorkError;

+ (instancetype)shareHandler;

- (void)startMonitorNetWorkStatus;

+ (void)cancleAllRequestItem;

- (XZNetworkItem *)requestUrl:(NSString *)urlString
                  requestType:(RequestType)type
                       params:(NSDictionary *)params
                      success:(XZRequestSuccessBlock)success
                       failus:(XZRequestFailureBlock)failure;






@end
