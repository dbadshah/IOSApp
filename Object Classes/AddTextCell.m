//
//  AddTextCell.m
//  EBroker
//
//  Created by Linath on 13/02/15.
//  Copyright (c) 2015 Linath. All rights reserved.
//

#import "AddTextCell.h"
#import "Utility.h"
@implementation AddTextCell
@synthesize txtField;
@synthesize imgViewBg;
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.txtField.textColor=[Utility getColor:TEXT_COLOR];
    self.txtField.font=[UIFont fontWithName:Helvetica_LT size:iPhone?16.0f:22.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
