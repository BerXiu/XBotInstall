//
//  AFNetworking+Center.m
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "AFNetworking+Center.h"
#import "HttpRequest.h"
#import "Configuration.h"

@implementation AFNetworking_Center


+ (void)x_getRequestBotsWithTarget:(id)target callBack:(SEL)callBack {
    
    [HttpRequest requestWithPath:BotsAPIHost target:target callBack:callBack];
}

+ (void)x_getRequestIntegrationsIDs:(NSString *)ids last:(NSInteger)last Target:(id)target callBack:(SEL)callBack {
    [HttpRequest requestWithPath:[NSString stringWithFormat:@"%@/%@/integrations?last=%ld", BotsAPIHost, ids, last] target:target callBack:callBack];
}

@end
