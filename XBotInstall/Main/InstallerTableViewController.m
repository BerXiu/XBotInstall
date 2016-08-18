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


@interface InstallerTableViewController ()

@property (nonatomic, strong) CommitsInfo *infoItems;

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
