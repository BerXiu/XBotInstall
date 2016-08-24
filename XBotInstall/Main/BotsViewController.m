//
//  BotsViewController.m
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "BotsViewController.h"
#import "HttpRequest.h"
#import "HttpResult.h"
#import "BotInfo.h"
#import <SVProgressHUD.h>
#import "BotCell.h"
#import "AFNetworking+Center.h"
#import "IntegrationsViewController.h"
#import <MJRefresh.h>
#import "EventCenter.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>


@interface BotsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BotInfo * info;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [AFNetworking_Center x_getRequestBotsWithTarget:self callBack:@selector(info:)];

    }];
}

- (void)info:(HttpResult *)result {
    
    if (result.isSuccess) {
        self.info = [BotInfo objectWithDictionary:result.result];
        [self.tableView reloadData];
    }
    [self.tableView.mj_header endRefreshing];
}

- (IBAction)cacheClick:(UIBarButtonItem *)sender {
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"确定要清除所有已经下载的安装文件吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
       
        if (buttonIndex == 1) {
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            BOOL bRet = [fileMgr fileExistsAtPath:[[EventCenter shared]documentPath]];
            if (bRet) {
                //
                NSError *err;
                [fileMgr removeItemAtPath:[NSString stringWithFormat:@"%@/ipas",[[EventCenter shared]documentPath]] error:&err];
                
            }
        }
    }];
}

#pragma mark -Navigation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.info.results.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BotCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[BotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    ResultsInfo *info = self.info.results[indexPath.row];
    cell.textLabel.text = info.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"push" sender:self.info.results[indexPath.row]];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    IntegrationsViewController * integrations = (IntegrationsViewController *)segue.destinationViewController;
    if (integrations) {
        integrations.integrations = sender;
    }
}


@end
