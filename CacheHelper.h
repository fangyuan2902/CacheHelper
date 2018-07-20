//
//  CacheHelper.h
//  ProjectDemo
//
//  Created by 远方 on 2017/2/27.
//  Copyright © 2017年 远方. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheHelper : NSObject

/**
 *  加入缓存 value/key
 */
+ (void)cacheKeyValues:(NSDictionary*)value forKey:(NSString*)key;

/**
 *  取出key对应的缓存
 */
+ (NSDictionary *)getCacheDictionaryForKey:(NSString*)key;

/**
 *  字符串缓存
 */
+ (void)cacheString:(NSString*)value forKey:(NSString*)key;

/**
 *  获取缓存中的字符串
 */
+ (NSString *)getStringForKey:(NSString*)key;

/**
 *  清空key对应的缓存
 */
+ (void)removeCacheForKey:(NSString*)key;

/**
 *  加入缓存 value（model）/key
 */
+ (void)cacheObjectData:(id)ojb forKey:(NSString*)key;


@end
