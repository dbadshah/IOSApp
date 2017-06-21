//
//  DropdownCell.m
//  EBroker
//
//  Created by Linath on 13/02/15.
//  Copyright (c) 2015 Linath. All rights reserved.
//

#import "DropdownCell.h"
#import "Utility.h"
@implementation DropdownCell
@synthesize lblTitle;
@synthesize imgView;
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.lblTitle.textColor=[Utility getColor:TEXT_COLOR];
    self.lblTitle.font=[UIFont fontWithName:Helvetica_LT size:iPhone?16.0f:22.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
