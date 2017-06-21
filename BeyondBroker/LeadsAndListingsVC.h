//
//  LeadsAndListingsVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 16/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeadsAndListingsVC : UIViewController
{
    IBOutlet UIView *viewLeads,*viewListing;
    IBOutlet UILabel *lblLeads,*lblListings;
    IBOutlet UIButton *btnLeadMinus,*btnLeadPlus,*btnListingPlus,*btnListingMinus;
}
@end

