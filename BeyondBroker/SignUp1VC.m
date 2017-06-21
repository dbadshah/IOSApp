//
//  SignUp1VC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 06/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "SignUp1VC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"
#import "AskAgentSellerVC.h"
@interface SignUp1VC ()

@end

@implementation SignUp1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnContinue.layer.cornerRadius=5.0;
    
    UIColor *color = [UIColor grayColor];
    txtFirsName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your first name" attributes:@{NSForegroundColorAttributeName: color}];
    
    txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your last name" attributes:@{NSForegroundColorAttributeName: color}];
}
-(IBAction)gotoSignUp2VC:(id)sender{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    
    if (txtFirsName.text.length<1) {
        
        [Utility showAlertWithTitle:@"Please enter first name" withMessage:nil];
        return;
    }
    else if (txtLastName.text.length<1)
    {
        [Utility showAlertWithTitle:@"Please enter last name" withMessage:nil];
        return;

    }
    
    
    
    
    NSString *post = [NSString stringWithFormat: @"firstname=%@&lastname=%@&token=%@&userid=%@",CHECK_NULL_STRING(txtFirsName.text),CHECK_NULL_STRING(txtLastName.text),STATIC_TOKEN,USER_ID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_profile"] withData:postData withMehtod:@"POST" withLoadingAlert:LOADING_TITLE withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
               // [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                //[[NSUserDefaults standardUserDefaults] synchronize];
                
                AskAgentSellerVC *objAskAgentSellerVC =[[AskAgentSellerVC alloc] initWithNibName:@"AskAgentSellerVC" bundle:nil];
                [self.navigationController pushViewController:objAskAgentSellerVC animated:true];
                
            }
            else if([[dict valueForKey:@"status"] integerValue]==2)
            {
                
                
                
            }
            else{
                
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

@end
