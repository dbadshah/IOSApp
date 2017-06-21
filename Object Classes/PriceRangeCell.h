//
//  PriceRangeCell.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 08/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceRangeCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIView *containerView;
@property(strong,nonatomic)IBOutlet UIButton *btnPriceRange;
@property(strong,nonatomic)IBOutlet UIButton *btnDelete;
@end
