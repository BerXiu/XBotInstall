//
//  HttpRequest.m
//  XBotInstall
//
//  Created by Xiu on 12/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "HttpRequest.h"
#import "BotsAPI.h"
#import "AFURLSessionManagerExtend.h"

@implementation HttpRequest

+ (void)x_getRequestWithTarget:(id)target callBack:(SEL)callBack {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManagerExtend *manager = [[AFURLSessionManagerExtend alloc]initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:BotsAPIHost]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@",responseObject);
    }];
    [dataTask resume];
}


@end
