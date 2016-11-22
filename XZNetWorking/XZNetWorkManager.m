//
//  XZNetWorkingManager.m
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZNetWorkManager.h"
#import "AFNetworking.h"
#import "XZNetWorkHandler.h"
#import "XZNetWorkingDefine.h"
@implementation XZNetWorkManager

+ (instancetype)manager
{
    static XZNetWorkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XZNetWorkManager alloc] init];
    });
    return manager;
}


+ (void)GETRequestWithUrl:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                  success:(XZRequestSuccessBlock)successBlock
                  failure:(XZRequestFailureBlock)failureBlock{
    
    [[XZNetWorkHandler shareHandler] requestUrl:URLString requestType:RequestTypeGet params:parameters success:successBlock failus:failureBlock] ;
    
}


+ (void)POSTRequestWithUrl:(NSString *)URLString
                parameters:(NSDictionary *)parameters
                   success:(XZRequestSuccessBlock)successBlock
                   failure:(XZRequestFailureBlock)failureBlock{
    
    [[XZNetWorkHandler shareHandler] requestUrl:URLString requestType:RequestTypePost params:parameters success:successBlock failus:failureBlock] ;

}




@end
