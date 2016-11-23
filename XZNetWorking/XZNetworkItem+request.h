//
//  XZNetworkItem+request.h
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZNetworkItem.h"

@interface XZNetworkItem (request)
/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return
 */
- (BOOL)haveSameRequestInTasksPool:(XZURLSessionTask *)task;

/**
 *  如果有旧请求则取消旧请求
 *
 *  @param task 新请求
 *
 *  @return 旧请求
 */
- (XZURLSessionTask *)cancleSameRequestInTasksPool:(XZURLSessionTask *)task;

@end
