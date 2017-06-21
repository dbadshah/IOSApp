//
//  SellingReasonVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 19/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@interface SellingReasonVC : UIViewController{
    
    
    IBOutlet UIView *dropDownView;
    IBOutlet UIView *otherView;
    IBOutlet UILabel *lblDropDown;
    IBOutlet UITextField *txtOther;


}
@property (nonatomic, strong) IBOutlet RadioButton* radioButton;
@property(strong,nonatomic) NSMutableArray *arrData;
-(IBAction)onRadioBtn:(id)sender;
@end
