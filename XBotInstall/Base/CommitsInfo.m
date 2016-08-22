//
//  CommitsInfo.m
//  XBotInstall
//
//  Created by Xiu on 17/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "CommitsInfo.h"

@implementation CommitsInfo

- (void)info:(NSDictionary *)info {
    NSDictionary *results = ((NSArray *)info[@"results"]).lastObject;
    NSMutableArray *array = [NSMutableArray new];
    if (((NSArray *)info[@"results"]).count <= 0) return ;
    
    NSString * key = [results[@"commits"] allKeys].lastObject;
    if (key) {
        for (NSDictionary *dic in results[@"commits"][key]) {
            CommitInfo *info = [CommitInfo objectWithDictionary:dic];
            [array addObject:info];
        }
        _commitInfo = [NSArray arrayWithArray:array];
        return;
    }
    NSLog(@"CommitsInfo解析失败");
}

@end



@implementation CommitInfo

@end



@implementation XCSCommitContributorInfo

@end