//
//  CommitsInfo.h
//  XBotInstall
//
//  Created by Xiu on 17/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSObject.h"

@class CommitInfo;
@class  XCSCommitContributorInfo;

@interface CommitsInfo : SSObject

@property (nonatomic, readonly) NSArray <CommitInfo *> * commitInfo;

- (void)info:(NSDictionary *)info;

@end


#pragma mark - commit信息
@interface CommitInfo : SSObject

/// commit 内容
@property (nonatomic, readonly) NSString * XCSCommitMessage;

/// commit 时间
@property (nonatomic, readonly) NSString * XCSCommitTimestamp;

/// 提交人信息
@property (nonatomic, readonly) XCSCommitContributorInfo * XCSCommitContributor;

@end


#pragma mark - 提交人信息
@interface XCSCommitContributorInfo : SSObject

/// 提交人名称
@property (nonatomic, readonly) NSString * XCSContributorName;

@end