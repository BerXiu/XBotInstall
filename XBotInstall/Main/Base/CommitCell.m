//
//  CommitCell.m
//  XBotInstall
//
//  Created by Xiu on 17/8/16.
//  Copyright © 2016年 Xiu. All rights reserved.
//

#import "CommitCell.h"
#import "NSString+Extend.h"
@interface CommitCell()

/// commit 提交人
@property (weak, nonatomic) IBOutlet UILabel *name;

/// commit 时间
@property (weak, nonatomic) IBOutlet UILabel *date;

/// commit 内容
@property (weak, nonatomic) IBOutlet UILabel *details;

@end

@implementation CommitCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)info:(CommitInfo *)info {
    
    self.name.text = [NSString stringWithFormat:@"提交人：%@",info.XCSCommitContributor.XCSContributorName];
    self.date.text = [NSString stringWithFormat:@"时间：%@",info.XCSCommitTimestamp.dateStringtoString];
    self.details.text = [NSString stringWithFormat:@"%@",info.XCSCommitMessage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
