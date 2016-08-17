//
//  IntegrationsViewController.m
//  XBotInstall
//
//  Created by Xiu on 16/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "IntegrationsViewController.h"
#import "DetailCell.h"
#import "UIViewController+HUD.h"
#import "AFNetworking+Center.h"
#import "HttpResult.h"
#import "IntegrationsInfo.h"
#import <NSObjectExtend/NSDate+extend.h>

@interface IntegrationsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IntegrationsInfo * info;

@end

@implementation IntegrationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Integrations";
    [self refresh];
}

- (void)refresh {
    
    [self HUDshow];
    [AFNetworking_Center x_getRequestIntegrationsIDs:self.integrations._id last:1000 Target:self callBack:@selector(result:)];
}

- (void)result:(HttpResult *)result {
    NSLog(@"%@",result.result);
    if (result.isSuccess) {
        
        self.info = [IntegrationsInfo objectWithDictionary:result.result];
        [self.tableView reloadData];
    }
    [self HUDdismiss];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.info.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntegrationsResultsInfo *integrationsResultsInfo = self.info.results[indexPath.section];
    InfoDictionaryInfo * infoDictionary = integrationsResultsInfo.assets.product.infoDictionary;
    
    switch (indexPath.row) {
        case 0:{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",infoDictionary.CFBundleDisplayName];
            
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            NSDate *date = [formatter dateFromString:integrationsResultsInfo.endedTime];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",date.toString];
            return cell;
        }
            break;
        case 1:{
            
            DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            [cell info:integrationsResultsInfo];
            return cell;
        }
            
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath.row == 0 ? 44: 84;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
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
