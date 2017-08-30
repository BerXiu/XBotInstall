//
//  EventCenter.m
//  XBotInstall
//
//  Created by Xiu on 22/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "EventCenter.h"
#import <RoutingHTTPServer.h>
#import <SVProgressHUD.h>
#import <QiniuSDK.h>
#import "Configuration.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>

@interface EventCenter()

@property (nonatomic, strong) RoutingHTTPServer * httpServer;

@end

@implementation EventCenter

+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    static EventCenter * eventCenter;
    dispatch_once(&onceToken, ^{
        eventCenter = [[EventCenter alloc]init];
    });
    return eventCenter;
}

- (BOOL)startServer
{
    if (!self.httpServer) {
        self.httpServer = [[RoutingHTTPServer alloc] init];
        [self.httpServer setType:@"_http._tcp."];
        [self.httpServer setPort:9527];
        [self.httpServer setDocumentRoot:[self documentPath]];
    }
    
    /// 如果已经开启 不需要重复开启服务
    if (self.httpServer.isRunning) {
        
        return YES;
    }
    
    NSError *error;
    if([self.httpServer start:&error]) {
        NSLog(@"Started HTTP Server on port %hu", [_httpServer listeningPort]);
        return YES;
    }else{
        [SVProgressHUD setStatus:[NSString stringWithFormat:@"Error starting HTTP Sever: %@",error]];
        // Probably should add an escape - but in practice never loops more than twice (bug filed on GitHub https://github
        [self startServer];
        return NO;
    }
}



- (void)installerApp:(ProductInfo *)info {
    
    [self createrPlistWithInfo:info];
    [self uploadThePlistToQiNiuWihtInfo:info];
}

/**
 *  创建Plist文件
 *  return Plist文件路径
 */
- (void)createrPlistWithInfo:(ProductInfo *)info {
    
    /// 创建文件
    NSFileManager *filemanager = [NSFileManager defaultManager];
    [filemanager createFileAtPath:[self setPlistPath] contents:nil attributes:nil];
    
    /// 绑定数据
    NSArray * assets = @[@{@"kind":@"software-package",@"url":[NSString stringWithFormat:@"http://127.0.0.1:9527/ipas/%lu.ipa",info.relativePath.hash]}];
    NSDictionary * metadata = @{
                                @"bundle-identifier":info.infoDictionary.CFBundleIdentifier,
                                @"bundle-version":
                                    info.infoDictionary.CFBundleShortVersionString,
                                @"kind":@"software",
                                @"title":info.infoDictionary.CFBundleDisplayName != nil ? info.infoDictionary.CFBundleDisplayName: info.infoDictionary.CFBundleName
                                };
    NSDictionary * item0 = @{@"assets":assets,@"metadata":metadata};
    NSDictionary * items = @{@"items": @[item0]};
    [items writeToFile:[self setPlistPath] atomically:true];
}

/**
 *  上传Plist到七牛
 */
- (void)uploadThePlistToQiNiuWihtInfo:(ProductInfo *)info {
    
    //通过七牛对象存储 存放Plist文件
    QNUploadManager * upManager = [[QNUploadManager alloc]init];
    QNUploadOption * upOption = [[QNUploadOption alloc]initWithMime:@"text/plain" progressHandler:nil params:nil checkCrc:true cancellationSignal:nil];
    NSData * plistData = [NSData dataWithContentsOfFile:[self setPlistPath]];
    
    if (plistData) {
        
        /// plist Name
        NSString * key = [NSString stringWithFormat:@"%@_%@_%@_%@",info.fileName,info.infoDictionary.CFBundleIdentifier, info.infoDictionary.CFBundleShortVersionString,info.infoDictionary.CFBundleVersion];
        
        [upManager putData:plistData key:key token:QiNiuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (info.statusCode == 200 || info.statusCode == 614) {
                ///开始安装
                [self startInstallWithKey:key];
            }else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error starting QiNiu : %d",info.statusCode]];
            }
            
        } option:upOption];
        
    }
}

/**
 * plist文件本地路径
 * @return  返回plist文件本地路径
 */
- (NSString *)setPlistPath {
    
    return [NSString stringWithFormat:@"%@/install.plist",[[EventCenter shared] documentPath]];
}

- (void)startInstallWithKey:(NSString *)key {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@%@",PlistPath,key]];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        
        [[UIApplication sharedApplication]openURL:url];
    }else {
        [UIAlertView bk_showAlertViewWithTitle:@"不能打开安装链接" message:@"" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
    }
    
}

-(NSString *)documentPath {
    
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

- (NSURL *)createApisPathWithName:(NSString *)name {
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSURL *documentsDirectoryURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    [fileManager createDirectoryAtURL:[documentsDirectoryURL URLByAppendingPathComponent:@"ipas"] withIntermediateDirectories:YES attributes:nil error:nil];
    
    return  [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"ipas/%@.ipa",name]];
}


@end
