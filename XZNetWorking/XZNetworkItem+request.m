//
//  XZNetworkItem+request.m
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZNetworkItem+request.h"

@interface NSURLRequest (XZRequest)

//判断是否是同一个请求（依据是请求url和参数是否相同）
- (BOOL)isTheSameRequest:(NSURLRequest *)request;

@end

@implementation NSURLRequest (XZRequest)

- (BOOL)isTheSameRequest:(NSURLRequest *)request {
    if ([self.HTTPMethod isEqualToString:request.HTTPMethod]) {
        if ([self.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
            if ([self.HTTPMethod isEqualToString:@"GET"]||[self.HTTPBody isEqualToData:request.HTTPBody]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
@implementation XZNetworkItem (request)

- (BOOL)haveSameRequestInTasksPool:(XZURLSessionTask *)task {
    __block BOOL isSame = NO;
    
    [self.allTasks enumerateObjectsUsingBlock:^(XZURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            isSame  = YES;
            *stop = YES;
        }
    }];
    return isSame;
}

- (XZURLSessionTask *)cancleSameRequestInTasksPool:(XZURLSessionTask *)task {
    __block XZURLSessionTask *oldTask = nil;
    
    [self.allTasks enumerateObjectsUsingBlock:^(XZURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            if (obj.state == NSURLSessionTaskStateRunning) {
                [obj cancel];
                oldTask = obj;
            }
            *stop = YES;
        }
    }];
    
    return oldTask;
}





@end
