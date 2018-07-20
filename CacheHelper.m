//
//  CacheHelper.m
//  ProjectDemo
//
//  Created by 远方 on 2017/2/27.
//  Copyright © 2017年 远方. All rights reserved.
//

#import "CacheHelper.h"
#import <objc/runtime.h>

@implementation CacheHelper

+ (void)cacheKeyValues:(NSDictionary*)value forKey:(NSString*)key {
    value=[CacheHelper cleanNullInJsonDic:value];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)cleanNullInJsonDic:(NSDictionary *)dic {
    if (!dic || (id)dic == [NSNull null]) {
        return dic;
    }
    NSMutableDictionary *mulDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in [dic allKeys]) {
        NSObject *obj = dic[key];
        if (!obj || obj == [NSNull null]) {
            //            [mulDic setObject:[@"" JSONValue] forKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [mulDic setObject:[self cleanNullInJsonDic:(NSDictionary *)obj] forKey:key];
        }else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = [CacheHelper cleanNullInJsonArray:(NSArray *)obj];
            [mulDic setObject:array forKey:key];
        } else {
            [mulDic setObject:obj forKey:key];
        }
    }
    return mulDic;
}


+ (NSArray *)cleanNullInJsonArray:(NSArray *)array {
    if (!array || (id)array == [NSNull null]) {
        return array;
    }
    NSMutableArray *mulArray = [[NSMutableArray alloc] init];
    for (NSObject *obj in array) {
        if (!obj || obj == [NSNull null]) {
            //            [mulArray addObject:[@"" JSONValue]];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [self cleanNullInJsonDic:(NSDictionary *)obj];
            [mulArray addObject:dic];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *a = [CacheHelper cleanNullInJsonArray:(NSArray *)obj];
            [mulArray addObject:a];
        } else {
            [mulArray addObject:obj];
        }
    }
    return mulArray;
}

+ (NSDictionary *)getCacheDictionaryForKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)cacheString:(NSString*)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getStringForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
}

+ (void)removeCacheForKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)cacheObjectData:(id)ojb forKey:(NSString*)key {
    NSDictionary *dic = [CacheHelper getObjectData:ojb];
    [CacheHelper cacheKeyValues:dic forKey:key];
}

#pragma mark - Private Method
+ (NSDictionary *)getObjectData:(id)ojb {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([ojb class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [ojb valueForKey:propName];
        if(value == nil) {
            continue;
        } else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj {
    if([obj isKindOfClass:[NSString class]] ||
       [obj isKindOfClass:[NSNumber class]] ||
       [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[CacheHelper getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[CacheHelper getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [CacheHelper getObjectData:obj];
}

@end
