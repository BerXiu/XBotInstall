//
//  BotsViewController.m
//  XBotInstall
//
//  Created by Xiu on 15/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "BotsViewController.h"
#import "HttpRequest.h"

@interface BotsViewController ()

@end

@implementation BotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HttpRequest x_getRequestWithTarget:self callBack:@selector(info)];
}

-(void)info {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
