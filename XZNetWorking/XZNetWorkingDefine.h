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
 *  请求成功Block
 */
typedef void(^XZRequestSuccessBlock)(id response);

/**
 *  请求失败Block
 */
typedef void(^XZRequestFailureBlock)(NSError *error);

/**
 *  上传进度Block
 */
typedef void(^XZProgressBlock)(float uploadPercent, long long totalByteWritten, long long totalByteExpectedToWrite);

/**
 * 请求响应block
 */
typedef void(^XZResponseBlock)(id dataObj ,NSError *error);






