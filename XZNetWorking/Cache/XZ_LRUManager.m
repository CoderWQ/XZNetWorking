//
//  XZ_LRUManager.m
//  XZNetWorking
//
//  Created by coderXu on 16/11/24.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZ_LRUManager.h"

static NSString *const XZ_LRUManagerName = @"XZ_LRUManagerName";

static NSMutableArray *operationQueueArray = nil;

@implementation XZ_LRUManager

+ (XZ_LRUManager *)shareManager{
    static XZ_LRUManager *mgr ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[XZ_LRUManager alloc] init];
        
        
         if ([XZUserDefaults objectForKey:XZ_LRUManagerName]) {
            
            operationQueueArray = [NSMutableArray arrayWithArray:(NSArray *)[XZUserDefaults objectForKey:XZ_LRUManagerName]];
            
        }else{
            operationQueueArray = [NSMutableArray array];
        }
        
    });
    
    return mgr;
    
}

- (void)addFileToNode:(NSString *)fileName{
    
    NSArray *array = [operationQueueArray copy];
    
    // 倒序排列
    NSArray *reverseArray = [[array reverseObjectEnumerator] allObjects];
    
    [reverseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj[XZFileName] isEqualToString:fileName]) {
            
            [operationQueueArray removeObject:fileName];
            
            *stop = YES;
        }
    }];
    
    NSDate *nowDate = [NSDate date];
    
    NSDictionary *tempDict = @{XZFileName:fileName,XZDate:nowDate};
    
    [operationQueueArray addObject:tempDict];
    
    [XZUserDefaults setObject:operationQueueArray forKey:XZ_LRUManagerName];
    
    [XZUserDefaults synchronize];
    
    
}


- (void)refreshIndexOfFileNode:(NSString *)filename{
    
    [self addFileToNode:filename];
    
}
- (NSArray *)removeLRUFileNodeWithCacheTime:(NSTimeInterval)time {
    
    NSMutableArray *result = [NSMutableArray array];
    
    if (operationQueueArray.count > 0) {
        
        
        NSArray *tempArray = [operationQueueArray copy];
        
        [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDate *date = obj[XZDate];
            NSDate *newDate = [date dateByAddingTimeInterval:time];
            
            if ([XZNowDate compare:newDate] == NSOrderedDescending) {
                
                [result addObject:obj[XZFileName]];
                [operationQueueArray removeObjectAtIndex:idx];
              }
            
        }];
        
        if (result.count == 0) {
           NSString *removeFileName =  [operationQueueArray firstObject][XZFileName];
            [result addObject:removeFileName];
            [operationQueueArray removeObjectAtIndex:0];
        }
        
        [XZUserDefaults setObject:[operationQueueArray copy] forKey:XZ_LRUManagerName];
        [XZUserDefaults synchronize];
        
    }
    
    return [result copy];
    
}

- (NSArray *)currentQueue
{
    return [operationQueueArray copy];
}
@end
