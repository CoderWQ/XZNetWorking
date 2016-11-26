//
//  XZCacheManager.m
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZCacheManager.h"
#import "XZMemoryCache.h"
#import "XZDiskCache.h"
#import <CommonCrypto/CommonDigest.h>

#import "XZ_LRUManager.h"
static NSString *const XZCacheDirPathKey = @"XZCacheDirKey";

static NSUInteger diskCapacitys = 40 * 1000 * 1000;

static NSTimeInterval cacheTime = 7 * 24 * 60 * 60;


@implementation XZCacheManager

+ (instancetype)shareManager{
    
    static XZCacheManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[XZCacheManager alloc]init];
    });
    return mgr;
}

- (void)setCacheTime:(NSTimeInterval) time diskCapacity:(NSUInteger) capacity{
    
    cacheTime = time;
    diskCapacitys = capacity;
    
}





#pragma Mark- 存
- (void)saveCacheResponseObject:(id)responseObject
                 requestUrl:(NSString *)requestUrl
                     params:(NSDictionary *)params{
    
//    assert(responseObject);
//    assert(requestUrl);
//    
    if (!params)  params = @{};
    
    NSString *originStr  = [NSString stringWithFormat:@"%@%@",requestUrl,params];
    NSString *hash = [self md5:originStr];
    
    NSData *data = nil;
    NSError *error = nil;
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        data = responseObject;
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }else if ([responseObject isKindOfClass:[NSArray class]]){
        
        data = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
    }
    
    
    if (error == nil) {
        // 缓存 -> 内存
        [XZMemoryCache writeData:data forkey:hash];
        
        
        
        // 缓存 -> 硬盘
        NSString *directoryPath = nil;
        
        directoryPath = [XZUserDefaults objectForKey:XZCacheDirPathKey];
        
        if (!directoryPath) {
            directoryPath = XZCustomCacheFile;
            
            [XZUserDefaults setObject:directoryPath forKey:XZCacheDirPathKey];
            [XZUserDefaults synchronize];
        }
        
    
        
        [XZDiskCache writeData:data toDirPath:XZCustomCacheFile fileName:hash];
        
        
        [[XZ_LRUManager shareManager] addFileToNode:hash];
        
    }
    
    
    
}

- (id)getCacheResponseObjectWithRequestUrl:(NSString *)requestUrl params:(NSDictionary *)params{
    
    
     assert(requestUrl);
    
    if (!params)  params = @{};
    
    id cacheData = nil;
    
    NSString *originString = [NSString stringWithFormat:@"%@%@",requestUrl,params];
    NSString *hash = [self md5:originString];
    
    // 先查内存
    cacheData = [XZMemoryCache readDataByKey:hash];
    
    if (!cacheData) {
        NSString *dirPath = [XZUserDefaults objectForKey:XZCacheDirPathKey];
        
        if (dirPath) {
            cacheData = [XZDiskCache readDataFromDirPath:dirPath filename:hash];
            
            if (cacheData) {
                [[XZ_LRUManager shareManager] refreshIndexOfFileNode:hash];
            }
        }
        
    }
    
    return cacheData;
    
    
}



- (void)clearLRUCache{
    
    if ([self totalCacheSize] > diskCapacitys) {
        
        NSArray *deleteFiles = [[XZ_LRUManager shareManager] removeLRUFileNodeWithCacheTime:cacheTime];
        NSString *dirPath = [XZUserDefaults objectForKey:XZCacheDirPathKey];
        
        if (dirPath && deleteFiles.count > 0) {
            // 如果有删除的
            [deleteFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *filePath = [dirPath stringByAppendingPathComponent:obj];
                
                [XZDiskCache deleteCache:filePath];
            }];
        }
        
        
    }
    
 
 
    
}

- (unsigned long long)totalCacheSize {
    NSString *diretoryPath = [XZUserDefaults objectForKey:XZCacheDirPathKey];
    return [XZDiskCache dataSizeInDirPath:diretoryPath];
}


#pragma mark - 散列值
- (NSString *)md5:(NSString *)string {
    if (string == nil || string.length == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH],i;
    
    CC_MD5([string UTF8String],(int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],digest);
    
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x",(int)(digest[i])];
    }
    
    return [ms copy];
}

@end
