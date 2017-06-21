//
//  SelectAgentCell.h
//  BeyondBroker
//
//  Created by Webcore Solution on 13/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAgentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnAgentName;
@property (strong, nonatomic) IBOutlet UILabel *firmname;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIView *rateView;
@property (strong, nonatomic) IBOutlet UILabel *lblReviews;
@property (strong, nonatomic) IBOutlet UILabel *lblExprince;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (strong, nonatomic) IBOutlet UILabel *lblRecentcount;

@end
