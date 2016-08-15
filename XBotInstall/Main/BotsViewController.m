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

@interface BotsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BotInfo * info;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self HUDshow];
    self.title = @"Bots";
    [HttpRequest x_getRequestWithTarget:self callBack:@selector(info:)];
}

-(void)info:(HttpResult *)result {
    if (result.isSuccess) {
        NSLog(@"%@",result.result);
        self.info = [BotInfo objectWithDictionary:result.result];
        [self HUDdismiss];
        [self.tableView reloadData];
        return ;
    }
    
    [self HUDshowErrorWithStatus:result.message];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
