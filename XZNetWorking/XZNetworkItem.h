//
//  XZNetworkItem.h
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZNetWorkingDefine.h"

@interface XZNetworkItem : NSObject

@property(nonatomic,weak)id<XZNetWorkDelegate> delegate;

@property (nonatomic,assign)RequestType requsetType;

@property (nonatomic,strong)NSString *urlString;

@property (nonatomic,strong)NSDictionary *params;

@property (nonatomic,copy)XZRequestSuccessBlock success;

@property (nonatomic,copy)XZRequestFailureBlock failure;


- (XZNetworkItem *)initWithRequetType:(RequestType)requestType
                                  Url:(NSString *)url
                               params:(NSDictionary *)params
                              success:(XZRequestSuccessBlock)success
                              failure:(XZRequestFailureBlock)failure;

@end
