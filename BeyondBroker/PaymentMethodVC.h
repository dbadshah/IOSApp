//
//  PaymentMethodVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 16/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"

@interface PaymentMethodVC : UIViewController
{
    IBOutlet UIView *viewCreditCard,*viewExpDate,*viewSecurityCode;
    
    IBOutlet UITextField *txtCreditCard,*txtSecurityCode,*txtExpDate;
}
@end
