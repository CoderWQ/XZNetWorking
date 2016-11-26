//
//  XZNetWorkingManager.m
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZNetWorkManager.h"
#import "AFNetworking.h"
#import "XZNetWorkingDefine.h"
#import "XZNetworkItem.h"

static NSDictionary *headers;


@implementation XZNetWorkManager



+ (instancetype)manager
{
    static XZNetWorkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XZNetWorkManager alloc] init];
        // 初始化的时候设定的均为需要
        [manager configerDefaultParms];
    });
    
    return manager;
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader{
    headers = httpHeader;
}


+ (void)setupTimeout:(NSTimeInterval)timeout{
    
    [XZNetworkItem setupTimeout:timeout];
}



- (void)GETRequestWithUrl:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                  success:(XZRequestSuccessBlock)successBlock
                  failure:(XZRequestFailureBlock)failureBlock{
    
    
    self.item = [[XZNetworkItem alloc] initWithRequetType:RequestTypeGet Url:URLString cache:self.haveCache refreshRequest:self.refresh graceTime:self.graceTimeType params:parameters progress:nil success:successBlock failure:failureBlock];
    
    // 恢复默认配置
    [self configerDefaultParms];
 

     
}







- (void)configerDefaultParms{
    
    [self setupRefresh:XZDefaultRefresh HaveCache:XZDefaultCache showHud:XZDefaultGraceTimeType];
}



- (void)setupRefresh:(BOOL)refresh HaveCache:(BOOL)haveCache showHud:(XZNetworkRequestGraceTimeType)graceTimeType{
    
    self.refresh = refresh;
    self.haveCache = haveCache;
    self.graceTimeType = graceTimeType;
    
}


#pragma mark - 取消相关请求
+ (void)cancelRequestWithURL:(NSString *)url{
    
    [XZNetworkItem cancelRequestWithURL:url];
    
}
+ (void)cancelAllRequest{
    [XZNetworkItem cancelAllRequest];
}


@end
