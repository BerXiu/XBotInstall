//
//  BotInfo.m
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "BotInfo.h"

@implementation BotInfo

-(Class)arrayClassWithPropertyName:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"results"]) {
        return ResultsInfo.class;
    }
    return nil;
}
@end


@implementation ResultsInfo


@end
