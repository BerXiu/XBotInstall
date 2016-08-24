//
//  HttpRequest.h
//  XBotInstall
//
//  Created by Xiu on 12/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

/**
 *  网路请求
 */
+ (void)requestWithPath:(NSString *)path target:(id)target callBack:(SEL)callBack;


/**
 *  文件下载
 */
+ (void)downloadWithPath:(NSString *)path savePath:(NSURL *)saveURL target:(id)target callBack:(SEL)callBack;
@end
