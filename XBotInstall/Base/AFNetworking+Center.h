//
//  AFNetworking+Center.h
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetworking_Center : NSObject

/**
 *  请求Bots列表
 */
+ (void)x_getRequestBotsWithTarget:(id)target callBack:(SEL)callBack;

/**
 *  请求集成列表
 */
+ (void)x_getRequestIntegrationsIDs:(NSString *)ids last:(NSInteger)last Target:(id)target callBack:(SEL)callBack;
@end
