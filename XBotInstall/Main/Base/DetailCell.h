//
//  DetailCell.h
//  XBotInstall
//
//  Created by Xiu on 16/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegrationsInfo.h"

@interface DetailCell : UITableViewCell

@property (nonatomic , strong) IntegrationsResultsInfo *integrationsResultsInfo;

- (void)info:(IntegrationsResultsInfo *)info;

@end
