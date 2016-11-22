
//
//  XZNetworkItem.m
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZNetworkItem.h"
#import "AFNetworking.h"
@implementation XZNetworkItem

- (XZNetworkItem *)initWithRequetType:(RequestType)requestType
                                  Url:(NSString *)url
                               params:(NSDictionary *)params
                              success:(XZRequestSuccessBlock)success
                              failure:(XZRequestFailureBlock)failure{
    
    self = [super init];
    if (self) {
        self.requsetType = requestType;
        self.urlString = url;
        self.params = params;
        self.success = success;
        self.failure = failure;
    }
    NSLog(@"请求地址%@",self.urlString);
    NSLog(@"请求参数%@",self.params);

    AFHTTPSessionManager *manager = [self getManager];
    switch (requestType) {
        case RequestTypeGet:
            [self GETSessionByManager:manager];
            break;
        case RequestTypePost:
            [self POSTSessionByManager:manager];
            break;
        default:
            break;
    }
    
    
    return self;
}

#pragma  mark -GET请求
- (void)GETSessionByManager:(AFHTTPSessionManager *)mgr{
    
    __weak typeof (self)weakSelf = self;
    
    
    [mgr GET:self.urlString parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[NSThread currentThread]);

        if (weakSelf.success) {
            weakSelf.success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[NSThread currentThread]);

        if (weakSelf.failure) {
             weakSelf.failure(error);
        }
      
    }];
   
}
#pragma  mark -POST请求
- (void)POSTSessionByManager:(AFHTTPSessionManager *)mgr{

    __weak typeof (self)weakSelf = self;
    
    [mgr POST:self.urlString parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (weakSelf.success) {
            weakSelf.success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (weakSelf.failure) {
            weakSelf.failure(error);
        }
    }];
}


- (void)removeItem{
    
    __weak typeof (self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(removeXZNetWorkItem:)]) {
            
            [self.delegate removeXZNetWorkItem:weakSelf];
        }
    });
}

- (AFHTTPSessionManager *)getManager{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"image/jpeg",@"text/html", nil];
/**************************************************************************************/
    // 1.证书转换
    //    openssl x509 -in 你的证书.crt -out 你的证书.cer -outform der
    //     openssl x509 -in testzc.crt -out testzc1.cer -outform der
    //    在钥匙串中，到处项目，为.cer文件
    
    // 2.不需要证书就这么做
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
    
     //3.需要证书
//        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"testzc1" ofType:@"cer"];
//        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//        NSLog(@"%@", cerData);
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
//        manager.securityPolicy.allowInvalidCertificates = YES;
//        [manager.securityPolicy setValidatesDomainName:NO];
/**************************************************************************************/

    /*********************AFN2.0**************************************
    
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"testzc1" ofType:@"cer"];
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    _sharedClient.securityPolicy =  [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    _sharedClient.securityPolicy.pinnedCertificates = [[NSArray alloc] initWithObjects:cerData, nil];
    _sharedClient.securityPolicy.allowInvalidCertificates = YES;
    [_sharedClient.securityPolicy setValidatesDomainName:YES];
**************************************************************************************/
    
    
    // 请求超时设定
//    manager.requestSerializer.timeoutInterval = 10;
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    
    return manager;
}
@end
