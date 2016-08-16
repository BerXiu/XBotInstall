//
//  IntegrationsInfo.m
//  XBotInstall
//
//  Created by Xiu on 16/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "IntegrationsInfo.h"

@implementation IntegrationsInfo

-(Class)arrayClassWithPropertyName:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"results"]) {
        return IntegrationsResultsInfo.class;
    }
    return nil;
}
@end

@implementation IntegrationsResultsInfo


@end

@implementation AssetsInfo
@end

@implementation ProductInfo
@end

@implementation InfoDictionaryInfo
@end