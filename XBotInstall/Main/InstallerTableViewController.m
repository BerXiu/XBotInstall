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
#import <RoutingHTTPServer.h>

@interface InstallerTableViewController ()

@property (nonatomic, strong) CommitsInfo *infoItems;

@property (nonatomic, strong) RoutingHTTPServer * httpServer;

@end

@implementation InstallerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [self.httpServer setDocumentRoot:documentsDirectory];   //设置root路径
    
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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.infoItems.commitInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    [cell info:self.infoItems.commitInfo[indexPath.row]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
