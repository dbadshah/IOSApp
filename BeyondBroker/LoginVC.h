//
//  LoginVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 06/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController
{
    
    IBOutlet UIButton *btnContinue,*btnForgotPass;
    IBOutlet UITextField *txtEmail,*txtPassword;
}
@property(strong,nonatomic) NSDictionary *Dictparam;
@end
