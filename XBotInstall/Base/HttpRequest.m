//
//  HttpRequest.m
//  XBotInstall
//
//  Created by Xiu on 12/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "HttpRequest.h"
#import "Configuration.h"
#import "AFURLSessionManagerExtend.h"
#import "HttpResult.h"

@implementation HttpRequest

+(instancetype)shared {
    static dispatch_once_t onceToken;
    static HttpRequest *request;
    dispatch_once(&onceToken, ^{
        request = [[HttpRequest alloc]init];
    });
    return request;
}




+ (void)requestWithPath:(NSString *)path target:(id)target callBack:(SEL)callBack {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManagerExtend *manager = [[AFURLSessionManagerExtend alloc]initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        HttpResult *result = [HttpResult createWithResult:responseObject message:@"获取数据成功" code:200];
        
        [[HttpRequest shared]callBackTarget:target selector:callBack result:result];
    }];
    [dataTask resume];
    
}
+ (void)x_getRequestWithTarget:(id)target callBack:(SEL)callBack {

}

- (void)callBackTarget:(id)target selector:(SEL)selector result:(HttpResult *)result
{
    if (!target) return;
    
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:selector];
    
    if (methodSignature == nil)
    {
        methodSignature = [[target class] instanceMethodSignatureForSelector:selector];
    }
    
    if (methodSignature == nil) return;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    [invocation setTarget:target];
    
    [invocation setSelector:selector];
    
    [invocation setArgument:&result atIndex:2];
    
    [invocation invoke];
}



@end
