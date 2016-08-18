//
//  NSString+Extend.m
//  XBotInstall
//
//  Created by Xiu on 18/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "NSString+Extend.h"
#import <NSObjectExtend/NSDate+extend.h>

@implementation NSString(NSString_Extend)

- (NSString *)dateStringtoString {
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSDate *date = [formatter dateFromString:self];
    return [NSString stringWithFormat:@"%@",date.toString];
}

@end
