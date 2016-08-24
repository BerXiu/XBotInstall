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
#import <SVProgressHUD.h>
#import "EventCenter.h"

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

    [HttpRequest urlRequestWithPath:path savePaht:nil target:target callBack:callBack];
}

+ (void)downloadWithPath:(NSString *)path savePath:(NSURL *)saveURL target:(id)target callBack:(SEL)callBack {
    
    [HttpRequest urlRequestWithPath:path savePaht:saveURL target:target callBack:callBack];
}

+ (void)urlRequestWithPath:(NSString *)path savePaht:(NSURL *)saveURL target:(id)target callBack:(SEL)callBack {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManagerExtend *manager = [[AFURLSessionManagerExtend alloc]initWithSessionConfiguration:configuration];
    NSString *strPaht = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strPaht]];
    
    if (!saveURL) { //数据请求
        NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if (!error) {
                HttpResult * result = [HttpResult createWithResult:responseObject message:@"获取数据成功" code:200];
                [[HttpRequest shared]callBackTarget:target selector:callBack result:result];
            }else{
                HttpResult * result = [HttpResult createWithResult:error.userInfo message:@"获取数据失败" code:error.code];
                [[HttpRequest shared]callBackTarget:target selector:callBack result:result];
            }
            
        }];
        [dataTask resume];
        
    }else { /// 下载文件

        NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

            [SVProgressHUD showProgress:downloadProgress.fractionCompleted status:[NSString stringWithFormat:@"%0.2f%%",downloadProgress.fractionCompleted * 100]];
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return saveURL;
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
            if (!error) {
                [SVProgressHUD dismiss];
                HttpResult * result = [HttpResult createWithResult:response message:@"下载成功" code:200];
                
                [[HttpRequest shared]callBackTarget:target selector:callBack result:result];
            }else{
                HttpResult * result = [HttpResult createWithResult:error.userInfo message:@"获取数据失败" code:error.code];
                [[HttpRequest shared]callBackTarget:target selector:callBack result:result];
            }
        }];
        [downloadTask resume];
    }
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
