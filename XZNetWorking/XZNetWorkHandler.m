//
//  XZNetWorkHandler.m
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZNetWorkHandler.h"
#import "AFNetworkReachabilityManager.h"
@implementation XZNetWorkHandler

+ (instancetype)shareHandler
{
    static XZNetWorkHandler *netWrokHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWrokHandler = [[XZNetWorkHandler alloc] init];
    });
    
    return netWrokHandler;
}


- (XZNetworkItem *)requestUrl:(NSString *)urlString
       requestType:(RequestType)type
            params:(NSDictionary *)params
           success:(XZRequestSuccessBlock)success
            failus:(XZRequestFailureBlock)failure{
    
    if (self.isNetWorkError) {
        if (failure) {
            failure(nil);
        }
        return nil;
    }
    
    self.item = [[XZNetworkItem alloc] initWithRequetType:type Url:urlString params:params success:success failure:failure];
    [self.items addObject:self.item];
    
    return self.item;
    
    
}



//监听网络状态
- (void)startMonitorNetWorkStatus
{
    
    AFNetworkReachabilityManager *manager  =  [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                [XZNetWorkHandler shareHandler].NetWorkError = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                [XZNetWorkHandler shareHandler].NetWorkError = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [XZNetWorkHandler shareHandler].NetWorkError = NO;
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [XZNetWorkHandler shareHandler].NetWorkError = NO;
                NSLog(@"WAN网络");
                break;
        }
    }];
    [manager startMonitoring];
}


- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
        
    }
    return _items;
}




+ (void)cancleAllRequestItem{
    
    XZNetWorkHandler *handler = [XZNetWorkHandler shareHandler];
    [handler.items removeAllObjects];
    handler.item = nil;
    
}

- (void)removeXZNetWorkItem:(XZNetworkItem *)item
{
    [self.items removeObject:item];
    self.item = nil;
}



@end
