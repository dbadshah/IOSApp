//
//  SignUp2VC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 06/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "RegistrationVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "AppDelegate.h"
#import "WebServiceCall.h"
#import "SignUp1VC.h"
#import "AskAgentSellerVC.h"

#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface RegistrationVC () <GIDSignInDelegate, GIDSignInUIDelegate,FBLoginViewDelegate>

@end

@implementation RegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.Dictparam=[[NSDictionary alloc]init];
    
    // Do any additional setup after loading the view from its nib.
    lblPassHint.adjustsFontSizeToFitWidth=true;
    btnContinue.layer.cornerRadius=5.0;
    
    UIColor *color = [UIColor grayColor];
    txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your email" attributes:@{NSForegroundColorAttributeName: color}];
    
    txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter a password" attributes:@{NSForegroundColorAttributeName: color}];

    txtRePassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Re-enter the password" attributes:@{NSForegroundColorAttributeName: color}];

    [GIDSignIn sharedInstance].uiDelegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveToggleAuthUINotification:)
     name:@"ToggleAuthUINotification"
     object:nil];
    
    [self toggleAuthUI];
}
- (IBAction)btnGoogleClick:(id)sender {
   
    [[GIDSignIn sharedInstance] signIn];

}
- (IBAction)btnFacebookClick:(id)sender {
    
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        [self getFBInfo];
    }
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior=FBSDKLoginBehaviorWeb;
   
    [login logInWithReadPermissions:@[@"public_profile",@"email"]  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            
            
        } else if (result.isCancelled) {
            
            
        } else if ([result.grantedPermissions containsObject:@"email"]) {
            
            if ([FBSDKAccessToken currentAccessToken])
            {
                
                [self getFBInfo];
                
            }
        }
        
    }];
}

-(void)getFBInfo{
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,first_name,last_name,picture.type(large)" forKey:@"fields"];
  
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             
             NSString *facebook_id=[NSString stringWithFormat:@"%@",[result valueForKey:@"id"]];
             NSString *first_name=[NSString stringWithFormat:@"%@",[result valueForKey:@"first_name"]];
             NSString *last_name=[NSString stringWithFormat:@"%@",[result valueForKey:@"last_name"]];
             NSString *Email=[NSString stringWithFormat:@"%@",[result valueForKey:@"email"]];
             
             if (Email == nil || Email == (id)[NSNull null] || [Email isEqualToString:@"(null)"]) {
                 
                 Email=facebook_id;
                 
             }else{
                 
                 NSLog(@"is email");
                 
             }

             
             NSString *post = [NSString stringWithFormat: @"email=%@&firstname=%@&lastname=%@&token=%@",CHECK_NULL_STRING(Email),CHECK_NULL_STRING(first_name),CHECK_NULL_STRING(last_name),STATIC_TOKEN];
           
             NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
             [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/facebook_register"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
                 
                 
                 NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
                 
                 
                 
                 if (success) {
                     
                     NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                     
                     
                     if([[dict valueForKey:@"status"] integerValue]==1)
                     {
                         
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         AskAgentSellerVC *objAskAgentSellerVC =[[AskAgentSellerVC alloc] initWithNibName:@"AskAgentSellerVC" bundle:nil];
                         [self.navigationController pushViewController:objAskAgentSellerVC animated:true];
                         
                     }
                     else{
                       
                         [FBSDKAccessToken setCurrentAccessToken:nil];
                         [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                         [self.navigationController popViewControllerAnimated:true];
                         return;
                     }
                 }
                 else{
                     [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
                      return;
                 }
                 
             }];
             
            }
     }];
}

-(IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
    
    [self toggleAuthUI];
}
- (IBAction)didTapDisconnect:(id)sender {
    
    [[GIDSignIn sharedInstance] disconnect];

}
- (void)toggleAuthUI {
    
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
        // Not signed in
        self.signInButton.hidden = NO;
        
        
   }else{
      
    
        
    }
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
   
    if (!error) {
        
        NSString *userId = user.userID;
        NSString *idToken = user.authentication.idToken;
        NSString *name = user.profile.name;
        NSString *email = user.profile.email;
        
        NSLog(@"Customer details: %@ %@ %@ %@", userId, idToken, name, email);
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ToggleAuthUINotification" object:nil];
    
}

- (void) receiveToggleAuthUINotification:(NSNotification *) notification {
   
    if ([[notification name] isEqualToString:@"ToggleAuthUINotification"]) {
       
        self.Dictparam=[notification userInfo];
       
        NSString *Email=[NSString stringWithFormat:@"%@",[self.Dictparam valueForKey:@"email"]];
        NSString *first_name=[NSString stringWithFormat:@"%@",[self.Dictparam valueForKey:@"firstname"]];
        NSString *last_name=[NSString stringWithFormat:@"%@",[self.Dictparam valueForKey:@"lastname"]];
        
        NSString *post = [NSString stringWithFormat: @"email=%@&firstname=%@&lastname=%@&token=%@",CHECK_NULL_STRING(Email),CHECK_NULL_STRING(first_name),CHECK_NULL_STRING(last_name),STATIC_TOKEN];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/google_register"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
            
            
            NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            
            if (success) {
                
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                
                
                if([[dict valueForKey:@"status"] integerValue]==1)
                {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    AskAgentSellerVC *objAskAgentSellerVC =[[AskAgentSellerVC alloc] initWithNibName:@"AskAgentSellerVC" bundle:nil];
                    [self.navigationController pushViewController:objAskAgentSellerVC animated:true];
                    
                }
                else{
                    
                    [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                    [self.navigationController popViewControllerAnimated:true];
                    return;
                }
            }
            else{
                [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
                
                return;
            }
            
        }];
        
    }
}
-(IBAction)continueBtnClick:(id)sender{

    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    if (txtEmail.text.length<1) {
        
        [Utility showAlertWithTitle:@"Please enter email address." withMessage:nil];

        return;
    }
    else
    {
        if (![Utility isValidEmail:txtEmail.text]) {
            
            [Utility showAlertWithTitle:@"Please enter valid email address." withMessage:nil];
            return;
            
        }
    }
    
    
    if (txtPassword.text.length<1)
    {
        [Utility showAlertWithTitle:@"Please enter password." withMessage:nil];
        return;
    }
    if (txtRePassword.text.length<1)
    {
        [Utility showAlertWithTitle:@"Please enter re-enter the password." withMessage:nil];
        return;
    }

    else{
        
        if (txtPassword.text.length<8) {
            
            [Utility showAlertWithTitle:@"Please enter valid password." withMessage:nil];
            return;
        }
        else{
            
            if(![Utility isValidPassword:txtPassword.text])
            {
                [Utility showAlertWithTitle:@"Please enter valid password." withMessage:nil];
                return;

            }
                
        }
        
    }
    if (![txtPassword.text isEqualToString:txtRePassword.text])
    {
        [Utility showAlertWithTitle:@"Both password are not same." withMessage:nil];
        return;
    }
    
    
    
    NSLog(@"%@",txtEmail.text);
    NSLog(@"%@",txtPassword.text);

    
    NSLog(@"%@",DEVICE_TOKEN);
    
    NSString *post = [NSString stringWithFormat: @"email=%@&password=%@&token=%@",CHECK_NULL_STRING(txtEmail.text),CHECK_NULL_STRING(txtPassword.text),STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    
    
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_register"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
               
                SignUp1VC *objSignUp1VC =[[SignUp1VC alloc] initWithNibName:@"SignUp1VC" bundle:nil];
                [self.navigationController pushViewController:objSignUp1VC animated:true];
                
            }
            else{
                
                [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                [self.navigationController popViewControllerAnimated:true];
                return;
            }
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            
            return;
        }
        
    }];
    
    
    //[self.navigationController popToRootViewControllerAnimated:true];
}
//-(BOOL)isValidPassword:(NSString *)passwordString
//{
//    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{10,}";
//    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
//    return [passwordTest evaluateWithObject:passwordString];
//}

@end
