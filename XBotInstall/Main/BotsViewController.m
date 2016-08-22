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
#import "UIViewController+HUD.h"
#import "BotCell.h"
#import "AFNetworking+Center.h"
#import "IntegrationsViewController.h"


@interface BotsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BotInfo * info;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bots";
    [self refresh];
}

- (void)refresh {
    [self HUDshow];
    [AFNetworking_Center x_getRequestBotsWithTarget:self callBack:@selector(info:)];
}

- (void)info:(HttpResult *)result {
    
    if (result.isSuccess) {
        self.info = [BotInfo objectWithDictionary:result.result];
        [self HUDdismiss];
        [self.tableView reloadData];
        return ;
    }
    [self HUDshowErrorWithStatus:result.message];
}

- (IBAction)cacheClick:(UIBarButtonItem *)sender {
    
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
