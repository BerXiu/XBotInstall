//
//  InstallerTableViewController.m
//  XBotInstall
//
//  Created by Xiu on 17/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "InstallerTableViewController.h"
#import "AFNetworking+Center.h"
#import "HttpResult.h"
#import "CommitsInfo.h"
#import "UIViewController+HUD.h"
#import "CommitCell.h"
#import <RoutingHTTPServer.h>
#import <QiniuSDK.h>
#import "Configuration.h"

@interface InstallerTableViewController ()

@property (nonatomic, strong) CommitsInfo *infoItems;

@property (nonatomic, strong) RoutingHTTPServer * httpServer;

@end

@implementation InstallerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
////       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://o9h7vfmdk.qnssl.com/iAuto360.ipa__cn.iauto360__5.1_241"]];
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/502088292/PlistFile/master/Install.plist"]];
    self.tableView.estimatedRowHeight = 71;
    self.title = @"Commit";
    [self refresh];
}

- (void)refresh {
    [self HUDshow];
    [AFNetworking_Center x_getRequestCommitIDs:self.integrationsResultsInfo._id target:self callBack:@selector(info:)];
}

- (void)info:(HttpResult *)result {
    
    if (result.isSuccess) {
        
        self.infoItems = [[CommitsInfo alloc]init];
        [self.infoItems info:result.result];
        [self.tableView reloadData];
        [self HUDdismiss];
    }
}

- (IBAction)sender:(UIBarButtonItem *)sender {
    [self HUDshow];
    [self startServer];
}

//开启httpServer服务
- (void)startServer
{
    self.httpServer = [[RoutingHTTPServer alloc] init];
    [self.httpServer setType:@"_http._tcp."];   //设置支持的协议
    [self.httpServer setPort:12345];    //设置端口号
    [self.httpServer setDocumentRoot:[self documentPath]];   //设置root路径
    
    if (self.httpServer.isRunning) [self.httpServer stop];
    
    NSError *error;
    if([self.httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [_httpServer listeningPort]);
        [self HUDdismiss];
        
        /// 服务开启成功下开始下载安装
        [self downloadHttpRequest];
    }
    else
    {
        [self HUDsetStatus:[NSString stringWithFormat:@"Error starting HTTP Sever: %@",error]];
        // Probably should add an escape - but in practice never loops more than twice (bug filed on GitHub https://github
        [self startServer];
    }
}

- (void)downloadHttpRequest {
    NSURL *saveURL = [[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    [AFNetworking_Center x_downloadWithPath:self.integrationsResultsInfo.assets.product.relativePath savePath:[NSString stringWithFormat:@"%@%lu.ipa",saveURL,self.integrationsResultsInfo.assets.product.relativePath.hash] target:self callBack:@selector(downloadInfo:)];
}

-(void)downloadInfo:(HttpResult *)result {
    
    if (result.isSuccess) {
        
        /// 生成Plist文件并且上传
        NSString *plistPath = [NSString stringWithFormat:@"%@/install.plist",[self documentPath]];
        NSFileManager *filemanager = [NSFileManager defaultManager];
        [filemanager createFileAtPath:plistPath contents:nil attributes:nil];
        
        /// 创建信息写入Plist文件
        
        NSArray * assets = @[@{@"kind":@"software-package",@"url":[NSString stringWithFormat:@"http://127.0.0.1:12345/%lu.ipa",self.integrationsResultsInfo.assets.product.relativePath.hash]}];
        NSDictionary * metadata = @{
                                    @"bundle-identifier":self.integrationsResultsInfo.assets.product.infoDictionary.CFBundleIdentifier,
                                    @"bundle-version":
                                        self.integrationsResultsInfo.assets.product.infoDictionary.CFBundleShortVersionString,
                                    @"kind":@"software",
                                    @"title":@"b"};
        NSDictionary * item0 = @{@"assets":assets,@"metadata":metadata};
        NSDictionary * items = @{@"items": @[item0]};
        [items writeToFile:plistPath atomically:true];
        
        //通过七牛对象存储 存放Plist文件
        QNUploadManager * upManager = [[QNUploadManager alloc]init];
        QNUploadOption * upOption = [[QNUploadOption alloc]initWithMime:@"text/plain" progressHandler:nil params:nil checkCrc:true cancellationSignal:nil];
        NSData * plistData = [NSData dataWithContentsOfFile:plistPath];
        
        if (plistData) {
            NSString * key = [NSString stringWithFormat:@"%@_1_%@__%@_%@",self.integrationsResultsInfo.assets.product.fileName,self.integrationsResultsInfo.assets.product.infoDictionary.CFBundleIdentifier, self.integrationsResultsInfo.assets.product.infoDictionary.CFBundleShortVersionString,self.integrationsResultsInfo.assets.product.infoDictionary.CFBundleVersion];
            
            [upManager putData:plistData key:key token:QiNiuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                if (info.statusCode == 200 || info.statusCode == 614) {
                    ///开始安装
                    NSLog(@"开始安装");
                    NSLog(@"%@",[self documentPath]);

                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://o9h7vfmdk.qnssl.com/%@",key]]];
                }else {
                    [self HUDshowErrorWithStatus:[NSString stringWithFormat:@"Error starting QiNiu : %d",info.statusCode]];
                }
                
            } option:upOption];
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.infoItems.commitInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    [cell info:self.infoItems.commitInfo[indexPath.row]];
    return cell;
}

-(NSString *)documentPath {
    
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

@end
