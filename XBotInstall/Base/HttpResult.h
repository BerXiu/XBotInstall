//
//  HttpResult.h
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResult : NSObject

/// 状态码
@property (nonatomic, readonly) NSInteger code;

/// 请求返回的状态信息
@property (nonatomic, readonly) NSString * message;

/// 请求返回的资源
@property (nonatomic, readonly) id result;

/// 是否获取成功
@property (nonatomic, readonly) BOOL isSuccess;


/**
 *  创建网络资源对象
 *  @param  result  资源
 *  @param  message 消息
 *  @param  code    状态码
 *  @return Object
 */
+ (instancetype)createWithResult:(id)result
                         message:(NSString *)message
                            code:(NSInteger)code;
@end
