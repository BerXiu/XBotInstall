//
//  HttpResult.m
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "HttpResult.h"
#import <SVProgressHUD.h>

@implementation HttpResult

+ (instancetype)createWithResult:(id)result
                         message:(NSString *)message
                            code:(NSInteger)code {
    HttpResult *info = [[self.class alloc]init];
    info->_result = result;
    info->_message = message;
    info->_code = code;
    
    if (code != 200) {
        [SVProgressHUD showErrorWithStatus:message];
    }
    
    return info;
}

-(BOOL)isSuccess{
    return  self.code == 200;
}

@end
