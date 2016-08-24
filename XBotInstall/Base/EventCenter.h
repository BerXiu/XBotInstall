//
//  EventCenter.h
//  XBotInstall
//
//  Created by Xiu on 22/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntegrationsInfo.h"

@interface EventCenter : NSObject

+ (instancetype)shared;


/**
 *  开启HttpSever服务
 *  return Yes 开启成功， NO 开启失败
 */
- (BOOL)startServer;

/**
 *  安装
 */
- (void)installerApp:(ProductInfo *)info;

/**
 *  获取document路径
 *  @return 路径
 */
- (NSString *)documentPath;

/**
 *  ipa存储路径
 *  @return 路径
 */
- (NSURL *)createApisPathWithName:(NSString *)name;


@end
