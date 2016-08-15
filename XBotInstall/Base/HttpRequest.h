//
//  HttpRequest.h
//  XBotInstall
//
//  Created by Xiu on 12/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void CallBack;
@interface HttpRequest : NSObject

+ (void)x_getRequestWithTarget:(id)target callBack:(SEL)callBack;

@end
