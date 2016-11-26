//
//  XZDiskCache.m
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "XZDiskCache.h"
#import "NSString+XZCacheExtension.h"


@implementation XZDiskCache


+ (void)writeData:(id)data
        toDirPath:(NSString *)directoryPath
         fileName:(NSString *)fileName{
    
    assert(data);
    assert(directoryPath);
    assert(fileName);
    
    NSError *error = nil;
    
  
    
    
    if (![XZFileManager fileExistsAtPath:directoryPath isDirectory:nil]) {
        
        [XZFileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
    
  
    
    if (error) {
        NSLog(@"创建失败--%@",error.localizedDescription);
    }

    NSString *filePath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
 
    
   BOOL success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    
    if (!success) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hahahha" object:nil];

    }
    
    
    
    
}
+ (id)readDataFromDirPath:(NSString *)directoryPath
                 filename:(NSString *)filename{
    
    assert(directoryPath);
    
    assert(filename);
    
    NSData *data = nil;
    
    NSString *path = [directoryPath stringByAppendingPathComponent:filename];
    
    data = [XZFileManager contentsAtPath:path];
    
    return  data;
    
    
}

+ (unsigned long long)dataSizeInDirPath:(NSString *)directoryPath{
    
    unsigned long long size = directoryPath.fileSize;

    return size;
    
}

+ (void)clearDataInDirPath:(NSString *)directoryPath{
    
    if (directoryPath) {
        if ([XZFileManager fileExistsAtPath:directoryPath isDirectory:nil]) {
            NSError *error = nil;
            [XZFileManager removeItemAtPath:directoryPath error:&error];
            if (error) {
                NSLog(@"清理缓存是出现错误：%@",error.localizedDescription);
            }
        }
    }
    
}
+ (void)deleteCache:(NSString *)fileUrl{
    
    if (fileUrl) {
        if ([XZFileManager fileExistsAtPath:fileUrl]) {
            NSError *error = nil;
            [XZFileManager removeItemAtPath:fileUrl error:&error];
            if (error) {
                NSLog(@"删除文件出现错误出现错误：%@",error.localizedDescription);
            }
        }else {
            NSLog(@"不存在文件");
        }
    }
    
}
 @end
