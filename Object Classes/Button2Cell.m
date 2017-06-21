//
//  Button2Cell.m
//  EBroker
//
//  Created by Linath on 04/06/15.
//  Copyright (c) 2015 Linath. All rights reserved.
//

#import "Button2Cell.h"
#import "Utility.h"
@implementation Button2Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
   // [self.btnCell.titleLabel setFont:[UIFont fontWithName:OpenSans_Light size:iPhone?16.0F:20.0f]];
    [self.btnCell setBackgroundColor:[Utility getColor:SECTION_BG_COLOR]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
