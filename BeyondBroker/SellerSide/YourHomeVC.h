//
//  YourHomeVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 18/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourHomeVC : UIViewController{
    
    IBOutlet UILabel *lblBeads;
    IBOutlet UILabel *lblBaths;
    IBOutlet UILabel *lblSqft;
    IBOutlet UILabel *lblYearBuilt;
    IBOutlet UIButton *btnBack;

}
@property(strong,nonatomic) NSString *Address;
@property(strong,nonatomic) NSString *Unit;
@property(strong,nonatomic)NSMutableArray *arrData;

@end
