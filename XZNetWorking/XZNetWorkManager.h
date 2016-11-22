//
//  XZNetWorkingManager.h
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZNetWorkingDefine.h"
@interface XZNetWorkManager : NSObject


+ (instancetype)manager;



+ (void)GETRequestWithUrl:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                  success:(XZRequestSuccessBlock)successBlock
                  failure:(XZRequestFailureBlock)failureBlock;

+ (void)POSTRequestWithUrl:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                  success:(XZRequestSuccessBlock)successBlock
                  failure:(XZRequestFailureBlock)failureBlock;






@end
