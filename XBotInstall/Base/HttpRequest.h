//
//  HttpRequest.h
//  XBotInstall
//
//  Created by Xiu on 12/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

+ (void)requestWithPath:(NSString *)path target:(id)target callBack:(SEL)callBack;

@end
