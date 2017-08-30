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
#import <SVProgressHUD.h>
#import "CommitCell.h"
#import "EventCenter.h"
#import <MJRefresh.h>

@interface InstallerTableViewController ()

@property (nonatomic, strong) CommitsInfo *infoItems;

@end

@implementation InstallerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 44;
    [self refresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [AFNetworking_Center x_getRequestCommitIDs:self.integrationsResultsInfo._id target:self callBack:@selector(info:)];
    }];
}

- (void)info:(HttpResult *)result {
    
    if (result.isSuccess) {
        
        self.infoItems = [[CommitsInfo alloc]init];
        [self.infoItems info:result.result];
        [self.tableView reloadData];
    }
    [self.tableView.mj_header endRefreshing];
}

- (IBAction)sender:(UIBarButtonItem *)sender {
    if ([[EventCenter shared] startServer]) [self downloadHttpRequest];
}


- (void)downloadHttpRequest {
 
    NSURL * savePath = [[EventCenter shared]createApisPathWithName:[NSString stringWithFormat:@"%lu",self.integrationsResultsInfo.assets.product.relativePath.hash]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:savePath.path]) {
        
         [AFNetworking_Center x_downloadWithPath:self.integrationsResultsInfo.assets.product.relativePath savePath:savePath target:self callBack:@selector(downloadInfo:)];
    }else {
        
        [[EventCenter shared]installerApp:self.integrationsResultsInfo.assets.product];
    }
    
}

-(void)downloadInfo:(HttpResult *)result {
    
    if (result.isSuccess) {
        [[EventCenter shared]installerApp:self.integrationsResultsInfo.assets.product];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.infoItems.commitInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    [cell info: self.infoItems.commitInfo[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8.0;
}


@end
