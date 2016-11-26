//
//  XZNetWorkingDefine.h
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#ifdef DEBUG
#define XZLOG(...) NSLog(__VA_ARGS__)
#define XZLOG_CURRENT_METHOD NSLog(@"%@-%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#define XZLOG(...) ;
#define XZLOG_CURRENT_METHOD ;
#endif

#import <Foundation/Foundation.h>
@class XZNetworkItem;

@protocol XZNetWorkDelegate <NSObject>

- (void)removeXZNetWorkItem:(XZNetworkItem *)item;

@end


typedef NS_ENUM(NSInteger, RequestType) {
    
    RequestTypeGet = 1,
    
    RequestTypePost = 2,

};

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, XZNetworkStatus) {
    /**
     *  未知网络
     */
    XZNetworkStatusUnknown             = 1 << 0,
    /**
     *  无法连接
     */
    XZNetworkStatusNotReachable        = 1 << 1,
    /**
     *  WWAN网络
     */
    XZNetworkStatusReachableViaWWAN    = 1 << 2,
    /**
     *  WiFi网络
     */
    XZNetworkStatusReachableViaWiFi    = 1 << 3
};
// 网络提示框的出现时机，若干秒后网络数据还未返回则出现提示框

/**
  网络提示框的出现时机
  如果0.5s后没返回数据，显示框。
  以此类推
 */
typedef NS_ENUM(NSUInteger, XZNetworkRequestGraceTimeType){
   
    XZNetworkRequestGraceTimeTypeNormal,  // 0.5s
    XZNetworkRequestGraceTimeTypeLong,    // 1s
    XZNetworkRequestGraceTimeTypeShort,   // 0.1s
    XZNetworkRequestGraceTimeTypeNone,     // 没有提示框
    XZNetworkRequestGraceTimeTypeAlways   // 总是有提示框
    
};



/**
 *  请求任务
 */
typedef NSURLSessionTask XZURLSessionTask;

/**
 *  请求成功Block
 */
typedef void(^XZRequestSuccessBlock)(id response);

/**
 *  请求失败Block
 */
typedef void(^XZRequestFailureBlock)(NSError *error);
/**
 *  下载进度的block
 */
typedef void(^XZDownloadProgress)(int64_t completedUnitCount,int64_t totalUnitCount);




/**
 *  上传进度Block
 */
typedef void(^XZProgressBlock)(float uploadPercent, long long totalByteWritten, long long totalByteExpectedToWrite);

/**
 * 请求响应block
 */
typedef void(^XZResponseBlock)(id dataObj ,NSError *error);






