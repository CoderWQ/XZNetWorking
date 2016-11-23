
//
//  XZNetworkItem.m
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZNetworkItem.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "XZNetworkItem+request.h"
#define XZ_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

#define XZ_ERROR [NSError errorWithDomain:@"com.caixindong.XZNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:XZ_ERROR_IMFORMATION}]

static NSMutableArray   *requestTasksPool;

static XZNetworkStatus  networkStatus;

static NSDictionary    *headers;

static NSTimeInterval  requestTimeout = 20.f;

@implementation XZNetworkItem

- (XZNetworkItem *)initWithRequetType:(RequestType)requestType
                                  Url:(NSString *)url
                                cache:(BOOL)cache
                       refreshRequest:(BOOL)refresh
                               params:(NSDictionary *)params
                             progress:(XZDownloadProgress)progress
                              success:(XZRequestSuccessBlock)success
                              failure:(XZRequestFailureBlock)failure{
    
    self = [super init];
    if (self) {
        
        self.requsetType = requestType;
        self.urlString = url;
        self.haveCache = cache;
        self.refresh = refresh;
        self.params = params;
        self.progress = progress;
        self.success = success;
        self.failure = failure;
        
    }
    NSLog(@"请求地址%@",self.urlString);
    NSLog(@"请求参数%@",self.params);

    AFHTTPSessionManager *manager = [self manager];
    
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
- (XZURLSessionTask *)GETSessionByManager:(AFHTTPSessionManager *)mgr{
    
    __weak typeof (self)weakSelf = self;
    
    
    //将session拷贝到堆中，block内部才可以获取得到session
    __block XZURLSessionTask *session = nil;
    
    // 1.判断网络请求
    if (networkStatus == XZNetworkStatusNotReachable) {
        if (_failure)
            _failure(XZ_ERROR);
        return session;
    }
    // 2.判断有无缓存
    
   
    // 3.正常发请求
    session = [mgr GET:self.urlString parameters:self.params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (_progress) {
            _progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[NSThread currentThread]);

        if (weakSelf.success) weakSelf.success(responseObject);
        
        // 如果有缓存，存思密达
        
        // 干掉当前的task
        if ([self.allTasks containsObject:session]) [self.allTasks removeObject:session];
       
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",[NSThread currentThread]);

        if (weakSelf.failure)  weakSelf.failure(error);
       
        
        if ([self.allTasks containsObject:session]) [self.allTasks removeObject:session];
       
      
    }];
    
    if ([self haveSameRequestInTasksPool:session] && !self.isRefresh) {
       // 有请求的时候且不刷新。取消当前请求就可以了。
        [session cancel];
        return session;
    }else{
        // 其他情况，有旧的删旧的 不管怎么样，都加数组了
        XZURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) {
            [self.allTasks removeObject:oldTask];
        }
        if (session) {
            [self.allTasks addObject:session];
        }
        [session resume];
        return session;
    }
    
    
    
    return session;
   
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

//- (AFHTTPSessionManager *)getManager{
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"image/jpeg",@"text/html", nil];
///**************************************************************************************/
//    // 1.证书转换
//    //    openssl x509 -in 你的证书.crt -out 你的证书.cer -outform der
//    //     openssl x509 -in testzc.crt -out testzc1.cer -outform der
//    //    在钥匙串中，到处项目，为.cer文件
//    
//    // 2.不需要证书就这么做
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        manager.securityPolicy.allowInvalidCertificates = YES;
//        [manager.securityPolicy setValidatesDomainName:NO];
//    
//     //3.需要证书
////        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"testzc1" ofType:@"cer"];
////        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
////        NSLog(@"%@", cerData);
////        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
////        manager.securityPolicy.allowInvalidCertificates = YES;
////        [manager.securityPolicy setValidatesDomainName:NO];
///**************************************************************************************/
//
//    /*********************AFN2.0**************************************
//    
//    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"testzc1" ofType:@"cer"];
//    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//    _sharedClient.securityPolicy =  [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    _sharedClient.securityPolicy.pinnedCertificates = [[NSArray alloc] initWithObjects:cerData, nil];
//    _sharedClient.securityPolicy.allowInvalidCertificates = YES;
//    [_sharedClient.securityPolicy setValidatesDomainName:YES];
//**************************************************************************************/
//    
//    
//    // 请求超时设定
////    manager.requestSerializer.timeoutInterval = 10;
//    //    manager.securityPolicy.allowInvalidCertificates = YES;
//    
//    return manager;
//}



- (AFHTTPSessionManager *)manager{
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
//    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    [self startMonitorNetWorkStatus];
    
    
    return manager;
}

//监听网络状态
- (void)startMonitorNetWorkStatus
{
    
    AFNetworkReachabilityManager *manager  =  [AFNetworkReachabilityManager sharedManager];
    
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                networkStatus = XZNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = XZNetworkStatusNotReachable;
                NSLog(@"无网络");
                 break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                networkStatus = XZNetworkStatusReachableViaWiFi;
                 NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                 NSLog(@"WAN网络");
                networkStatus = XZNetworkStatusReachableViaWWAN;

                
                
                break;
        }
    }];
    
    
    
    
    
}

- (NSMutableArray *)allTasks
{
    if (_allTasks == nil) {
        _allTasks = [NSMutableArray array];
    }
    return _allTasks;
}



+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) requestTasksPool = [NSMutableArray array];
    });
    
    return requestTasksPool;
}
@end
