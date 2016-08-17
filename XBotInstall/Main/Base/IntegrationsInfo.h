//
//  IntegrationsInfo.h
//  XBotInstall
//
//  Created by Xiu on 16/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <SSObject/SSObject.h>

@class AssetsInfo;
@class IntegrationsResultsInfo;
@class ProductInfo;
@class InfoDictionaryInfo;

#pragma mark - Integrations列表
@interface IntegrationsInfo : SSObject

/// 构建总数
@property (nonatomic, readonly) NSInteger count;

/// 构建信息
@property (nonatomic, readonly) NSArray <IntegrationsResultsInfo *> *results;

@end


#pragma mark - Integrations信息
@interface IntegrationsResultsInfo : SSObject

/// 构建开始时间
@property (nonatomic, readonly) NSString * startedTime;

/// 构建结束时间
@property (nonatomic, readonly) NSString * endedTime;

/// 构建ID
@property (nonatomic, readonly) NSString * _id;

/// 构建资源
@property (nonatomic, readonly) AssetsInfo * assets;

@end


#pragma mark - 构建资源
@interface AssetsInfo : SSObject

/// 配置信息
@property (nonatomic, readonly) ProductInfo * product;

@end


#pragma mark - ipa 信息
@interface ProductInfo : SSObject

/// ipa路径
@property (nonatomic, readonly) NSString * relativePath;

/// 大小
@property (nonatomic, readonly) NSString * size;

/// 名称
@property (nonatomic ,readonly) NSString * fileName;

/// 应用基本信息
@property (nonatomic, readonly) InfoDictionaryInfo * infoDictionary;

@end


#pragma mark -应用基本信息
@interface InfoDictionaryInfo : SSObject

/// 应用版本
@property (nonatomic, readonly) NSString * CFBundleShortVersionString;

/// 应用最低系统版本支持
@property (nonatomic, readonly) NSString * MinimumOSVersion;

/// 应用build号
@property (nonatomic, readonly) NSString * CFBundleVersion;

/// 应用名称
@property (nonatomic, readonly) NSString * CFBundleDisplayName;

/// 应用程序标识符
@property (nonatomic, readonly) NSString * CFBundleIdentifier;

@end
