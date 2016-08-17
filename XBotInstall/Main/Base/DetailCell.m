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

/// 应用程序标识符
@property (weak, nonatomic) IBOutlet UILabel *CFBundleIdentifier;

/// 应用版本
@property (weak, nonatomic) IBOutlet UILabel *CFBundleShortVersionString;

/// build版本
@property (weak, nonatomic) IBOutlet UILabel *CFBundleVersion;

/// 文件大小
@property (weak, nonatomic) IBOutlet UILabel *size;

/// 最低系统版本支持
@property (weak, nonatomic) IBOutlet UILabel *minimumOSVersion;

/// 路径
@property (weak, nonatomic) IBOutlet UILabel *relativePath;

@end

@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.relativePath.adjustsFontSizeToFitWidth = YES;
}

- (void)info:(IntegrationsResultsInfo *)info {
    
    self.fileName.text = [NSString stringWithFormat:@"名 称:%@",info.assets.product.fileName];
    self.CFBundleIdentifier.text = [NSString stringWithFormat:@"标志:%@",info.assets.product.infoDictionary.CFBundleIdentifier];
    self.CFBundleShortVersionString.text = [NSString stringWithFormat:@"版本:%@",info.assets.product.infoDictionary.CFBundleShortVersionString];
    self.CFBundleVersion.text = [NSString stringWithFormat:@"build:%@",info.assets.product.infoDictionary.CFBundleVersion];
    self.size.text = [NSString stringWithFormat:@"大小:%0.2f",[info.assets.product.size floatValue] / 1000000];
    self.minimumOSVersion.text = [NSString stringWithFormat:@"最低支持:%@",info.assets.product.infoDictionary.MinimumOSVersion];
    self.relativePath.text = [NSString stringWithFormat:@"路径:%@",info.assets.product.relativePath];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
