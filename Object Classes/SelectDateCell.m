//
//  SelectDateCell.m
//  EBroker
//
//  Created by Linath on 20/02/15.
//  Copyright (c) 2015 Linath. All rights reserved.
//

#import "SelectDateCell.h"
#import "Utility.h"
@implementation SelectDateCell
@synthesize lblSelectDate;
@synthesize imgView;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.lblSelectDate.font=[UIFont fontWithName:Helvetica_LT size:iPhone?14.0f:20.0f];
    self.lblSelectDateVal.font=[UIFont fontWithName:Helvetica_LT_Bold size:iPhone?14.0f:20.0f];
    self.lblSelectDate.textColor=[Utility getColor:TEXT_COLOR];
    self.lblSelectDateVal.textColor=[Utility getColor:TEXT_COLOR];

    self.lblSelectDate.adjustsFontSizeToFitWidth=true;
    self.lblSelectDateVal.adjustsFontSizeToFitWidth=true;
}




@end
