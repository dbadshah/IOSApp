//
//  ListingCell.h
//  Beyondbroker
//
//  Created by Webcore Solution on 29/03/17.
//  Copyright © 2017 Webcore Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblListed;

@end
