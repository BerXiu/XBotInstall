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

@interface CommitsInfo : SSObject

@property (nonatomic, strong) NSString * key;

@property (nonatomic, readonly) NSArray <CommitInfo *> * commitInfo;

@end


@interface CommitInfo : SSObject

@end