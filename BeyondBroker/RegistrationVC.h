//
//  SignUp2VC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 06/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
@interface RegistrationVC : UIViewController
{
    IBOutlet UILabel *lblPassHint;
    IBOutlet UIButton *btnContinue;
    
    IBOutlet UITextField *txtEmail,*txtPassword;
    IBOutlet UITextField *txtRePassword;
}
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property(strong,nonatomic) NSDictionary *Dictparam;
@end
