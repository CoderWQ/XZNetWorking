//
//  XZDiskCache.h
//  XZNetWorking
//
//  Created by coderXu on 16/11/23.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZDiskCache : NSObject

/**
 写到沙盒的哪里

 @param data 数据
 @param directoryPath 路径
 @param fileName 文件名
 */
+ (void)writeData:(id)data
        toDirPath:(NSString *)directoryPath
         fileName:(NSString *)fileName;

/**
 *  从磁盘读取数据
 *
 *  @param directory 目录
 *  @param filename  文件名
 *
 *  @return 数据
 */
+ (id)readDataFromDirPath:(NSString *)directoryPath
             filename:(NSString *)filename;

/**
 *  获取目录中文件总大小
 *
 *  @param directory 目录名
 *
 *  @return 文件总大小
 */
+ (unsigned long long)dataSizeInDirPath:(NSString *)directoryPath;
/**
 *  清理目录中的文件
 *
 *  @param directory 目录名
 */
+ (void)clearDataInDirPath:(NSString *)directoryPath;

/**
 *  删除某文件
 *
 *  @param fileUrl 文件路径
 */
+ (void)deleteCache:(NSString *)fileUrl;




@end
