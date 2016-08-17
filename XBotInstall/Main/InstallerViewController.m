//
//  InstallerViewController.m
//  XBotInstall
//
//  Created by Xiu on 17/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "InstallerViewController.h"
#import "AFNetworking+Center.h"
#import "HttpResult.h"
#import "CommitsInfo.h"

@interface InstallerViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation InstallerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
}

- (void)refresh {
    [AFNetworking_Center x_getRequestCommitIDs:self.integrationsResultsInfo._id target:self callBack:@selector(info:)];
}

- (void)info:(HttpResult *)result {
    CommitsInfo *info = [[CommitsInfo alloc]init];
    info.key = [result.result[@"results"][0][@"commits"] allKeys][0];
    info = [CommitsInfo objectWithDictionary:result.result[@"results"][0][@"commits"]];
    NSLog(@"%@",result.result[@"results"][0][@"commits"]);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
