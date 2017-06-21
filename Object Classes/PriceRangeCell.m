//
//  PriceRangeCell.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 08/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "PriceRangeCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation PriceRangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerView.layer.borderColor=[UIColor grayColor].CGColor;
    self.containerView.layer.borderWidth=1.0;
    self.containerView.layer.masksToBounds=true;
    self.containerView.layer.cornerRadius=3.0f;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
