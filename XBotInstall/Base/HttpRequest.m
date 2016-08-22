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

+ (void)downloadWithPath:(NSString *)path savePath:(NSString *)savePath target:(id)target callBack:(SEL)callBack {
    
    [HttpRequest urlRequestWithPath:path savePaht:savePath target:target callBack:callBack];
}

+ (void)urlRequestWithPath:(NSString *)path savePaht:(NSString *)savePath target:(id)target callBack:(SEL)callBack {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManagerExtend *manager = [[AFURLSessionManagerExtend alloc]initWithSessionConfiguration:configuration];
    NSString *strPaht = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strPaht]];
    
    if (!savePath) { //数据请求
        NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            HttpResult * result = [HttpResult createWithResult:responseObject message:@"获取数据成功" code:200];
            
            [[HttpRequest shared]callBackTarget:target selector:callBack result:result];
        }];
        [dataTask resume];
        
    }else { /// 下载文件
        NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

            [SVProgressHUD showProgress:downloadProgress.fractionCompleted status:[NSString stringWithFormat:@"%0.2f%%",downloadProgress.fractionCompleted * 100]];
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

            return [[NSURL alloc]initWithString:savePath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                
            }
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/BerXiu/PlistFile/master/bots.plist"]];
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
