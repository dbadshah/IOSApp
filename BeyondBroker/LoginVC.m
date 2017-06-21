//
//  LoginVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 06/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "LoginVC.h"
#import <QuartzCore/QuartzCore.h>
#import "AskAgentSellerVC.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"
#import "SignUp1VC.h"
#import "AskAgentSellerVC.h"
#import "RootViewController.h"
#import "CreateProfileVC.h"
#import "DashbordVC.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface LoginVC () <GIDSignInDelegate, GIDSignInUIDelegate,FBLoginViewDelegate>

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnContinue.layer.cornerRadius=5.0;
    
    UIColor *color = [UIColor grayColor];
    txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your email" attributes:@{NSForegroundColorAttributeName: color}];
    
    txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter a password" attributes:@{NSForegroundColorAttributeName: color}];
    
    
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
             NSString *Email=[NSString stringWithFormat:@"%@",[result valueForKey:@"email"]];
             
             if (Email == nil || Email == (id)[NSNull null] || [Email isEqualToString:@"(null)"]) {
                 
                 Email=facebook_id;
                 
             }else{
                 
                 NSLog(@"is email");
                 
             }
             
             
             NSString *post = [NSString stringWithFormat: @"email=%@&token=%@",CHECK_NULL_STRING(Email),STATIC_TOKEN];
             
             NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
             [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/facebook_login"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
                 
                 
                 NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
                 
                 
                 
                 if (success) {
                     
                     NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                     
                     
                     if([[dict valueForKey:@"status"] integerValue]==1)
                     {
                         
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.userid"] forKey:@"loginUserId"];
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.roleid"] forKey:@"roleId"];
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.firstname"] forKey:@"firstName"];
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.lastname"] forKey:@"lastName"];
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.email"] forKey:@"loginEmail"];
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.isagent_profile"] forKey:@"isAgentProfile"];
                         
                         [[NSUserDefaults standardUserDefaults] setBool:true forKey:IS_LOGIN];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         if ([[dict valueForKeyPath:@"data.roleid"] isEqualToString:@"3"]) {
                             
                             if ([[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"0"] || [[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"1"] || [[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"2"]) {
                                
                                 //agent
                                 //continue
                            CreateProfileVC *objCreateProfile =[[CreateProfileVC alloc] initWithNibName:@"CreateProfileVC" bundle:nil];
                            [self.navigationController pushViewController:objCreateProfile animated:true];
                                 
                             }
                             else if ([[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"3"])
                             {
                                 //agent
                                 //listing screen
                                 [APP_WINDOW setRootViewController:[Utility CreateAgentTabbar]];
                                 
                             }
                         }else if ([[dict valueForKeyPath:@"data.roleid"] isEqualToString:@"2"])
                         {
                             //goto seller
                             [APP_WINDOW setRootViewController:[Utility createHomeTabbar]];
                             
                             
                         }
                         
                     }else if([[dict valueForKey:@"status"] integerValue]==2){
                         
                         
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         SignUp1VC *objSignUp1VC =[[SignUp1VC alloc] initWithNibName:@"SignUp1VC" bundle:nil];
                         [self.navigationController pushViewController:objSignUp1VC animated:true];
                         
                         
                         
                     }else if([[dict valueForKey:@"status"] integerValue]==3){
                         
                         
                         [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         AskAgentSellerVC *objAskAgentSellerVC =[[AskAgentSellerVC alloc] initWithNibName:@"AskAgentSellerVC" bundle:nil];
                         [self.navigationController pushViewController:objAskAgentSellerVC animated:true];

                    }else{
                         
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
        NSString *post = [NSString stringWithFormat: @"email=%@&token=%@",CHECK_NULL_STRING(Email),STATIC_TOKEN];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/google_login"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
            
            
            NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            
            if (success) {
                
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                
                if([[dict valueForKey:@"status"] integerValue]==1)
                {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.userid"] forKey:@"loginUserId"];
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.roleid"] forKey:@"roleId"];
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.firstname"] forKey:@"firstName"];
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.lastname"] forKey:@"lastName"];
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.email"] forKey:@"loginEmail"];
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.isagent_profile"] forKey:@"isAgentProfile"];
                    
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:IS_LOGIN];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if ([[dict valueForKeyPath:@"data.roleid"] isEqualToString:@"3"]) {
                        
                        if ([[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"0"] || [[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"1"] || [[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"2"]) {
                            //agent
                            //continue
                            
                            CreateProfileVC *objCreateProfile =[[CreateProfileVC alloc] initWithNibName:@"CreateProfileVC" bundle:nil];
                            [self.navigationController pushViewController:objCreateProfile animated:true];
                            
                        }
                        else if ([[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"3"])
                        {
                            //agent
                           
                            [APP_WINDOW setRootViewController:[Utility CreateAgentTabbar]];
                            
                        }
                    }else if ([[dict valueForKeyPath:@"data.roleid"] isEqualToString:@"2"])
                    {
                        //goto seller
                        [APP_WINDOW setRootViewController:[Utility createHomeTabbar]];
                        
                        
                    }
                    
                }else if([[dict valueForKey:@"status"] integerValue]==2){
                    
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    SignUp1VC *objSignUp1VC =[[SignUp1VC alloc] initWithNibName:@"SignUp1VC" bundle:nil];
                    [self.navigationController pushViewController:objSignUp1VC animated:true];
                    
                    
                    
                }else if([[dict valueForKey:@"status"] integerValue]==3){
                    
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    AskAgentSellerVC *objAskAgentSellerVC =[[AskAgentSellerVC alloc] initWithNibName:@"AskAgentSellerVC" bundle:nil];
                    [self.navigationController pushViewController:objAskAgentSellerVC animated:true];
                    
                    
                }else{
                    
                    [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
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
-(IBAction)btnContinuePress:(id)sender{

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
    
    NSLog(@"%@",DEVICE_TOKEN);
    
    NSString *post = [NSString stringWithFormat: @"email=%@&password=%@&token=%@",CHECK_NULL_STRING(txtEmail.text),CHECK_NULL_STRING(txtPassword.text),STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_login"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                //firstName,lastName
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.userid"] forKey:@"loginUserId"];
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.roleid"] forKey:@"roleId"];
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.firstname"] forKey:@"firstName"];
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.lastname"] forKey:@"lastName"];
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.email"] forKey:@"loginEmail"];
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKeyPath:@"data.isagent_profile"] forKey:@"isAgentProfile"];

                [[NSUserDefaults standardUserDefaults] setBool:true forKey:IS_LOGIN];
                [[NSUserDefaults standardUserDefaults] synchronize];
        
                if ([[dict valueForKeyPath:@"data.roleid"] isEqualToString:@"3"]) {
                    
                    if ([[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"0"] || [[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"1"] || [[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"2"]) {
                        //agent
                        //continue
                        
                        CreateProfileVC *objCreateProfile =[[CreateProfileVC alloc] initWithNibName:@"CreateProfileVC" bundle:nil];
                        [self.navigationController pushViewController:objCreateProfile animated:true];
                        
                    }
                    else if ([[dict valueForKeyPath:@"data.isagent_profile"] isEqualToString:@"3"])
                    {
                        //agent
                        //listing screen
                        [APP_WINDOW setRootViewController:[Utility CreateAgentTabbar]];
                    
                    }
                }else if ([[dict valueForKeyPath:@"data.roleid"] isEqualToString:@"2"])
                {
                    //goto seller
                     [APP_WINDOW setRootViewController:[Utility createHomeTabbar]];
 
                
                }
              
            }else if([[dict valueForKey:@"status"] integerValue]==2){
                
                
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                SignUp1VC *objSignUp1VC =[[SignUp1VC alloc] initWithNibName:@"SignUp1VC" bundle:nil];
                [self.navigationController pushViewController:objSignUp1VC animated:true];
                
                
                
            }else if([[dict valueForKey:@"status"] integerValue]==3){
               
               
               [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
               AskAgentSellerVC *objAskAgentSellerVC =[[AskAgentSellerVC alloc] initWithNibName:@"AskAgentSellerVC" bundle:nil];
               [self.navigationController pushViewController:objAskAgentSellerVC animated:true];
               
               
           }else{
                
                [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                return;
            }
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            
            return;
        }
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:true];

}
@end
