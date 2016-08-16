//
//  BotInfo.h
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <SSObject.h>

@class ResultsInfo;
@class ConfigurationInfo;
@class IntegrationsInfo;

#pragma mark - Bot列表
@interface BotInfo : SSObject

@property (nonatomic, readonly) NSInteger  count;

@property (nonatomic, readonly)NSArray <ResultsInfo *> * results;

@end



#pragma mark - Bot信息
@interface ResultsInfo: SSObject

@property (nonatomic, readonly) NSString * name;

@property (nonatomic, readonly) NSString * tinyID;

@property (nonatomic, readonly) NSInteger  type;

@property (nonatomic, readonly) NSString * _id;

@end

