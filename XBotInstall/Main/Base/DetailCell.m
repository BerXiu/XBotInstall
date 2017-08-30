//
//  DetailCell.m
//  XBotInstall
//
//  Created by Xiu on 16/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "DetailCell.h"


@interface DetailCell()

/// 文件名称
@property (weak, nonatomic) IBOutlet UILabel * fileName;

/// 应用版本
@property (weak, nonatomic) IBOutlet UILabel *CFBundleShortVersionString;

/// 文件大小
@property (weak, nonatomic) IBOutlet UILabel *size;

/// 最低系统版本支持
@property (weak, nonatomic) IBOutlet UILabel *minimumOSVersion;

@end

@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)info:(IntegrationsResultsInfo *)info {
    
    self.fileName.text = [NSString stringWithFormat:@"名 称：%@",info.assets.product.fileName];
    self.CFBundleShortVersionString.text = [NSString stringWithFormat:@"版本：%@ - build - %@",info.assets.product.infoDictionary.CFBundleShortVersionString, info.assets.product.infoDictionary.CFBundleVersion];
    self.size.text = [NSString stringWithFormat:@"大小：%0.2fMB",[info.assets.product.size floatValue] / 1000000];
    self.minimumOSVersion.text = [NSString stringWithFormat:@"最低支持：iOS %@",info.assets.product.infoDictionary.MinimumOSVersion];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
