//
//  AskAgentSellerVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 06/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "AskAgentSellerVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "CreateProfileVC.h"
@interface AskAgentSellerVC ()

@end

@implementation AskAgentSellerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnAgent.layer.cornerRadius=5.0;
    btnSeller.layer.cornerRadius=5.0;
}
-(IBAction)selectAgentOrSeller:(UIButton *)btn{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
        
        
        NSString *post = [NSString stringWithFormat: @"roleid=%@&token=%@&userid=%@",[NSString stringWithFormat:@"%ld",(long)btn.tag],STATIC_TOKEN,USER_ID];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_role_select"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
            
            
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
                            
//                            RootViewController *objRootVC =[[RootViewController alloc] init];
//                            
//                            UINavigationController *navController =[[UINavigationController alloc] initWithRootViewController:objRootVC];
//                            [APP_WINDOW setRootViewController:navController];

                            [APP_WINDOW setRootViewController:[Utility CreateAgentTabbar]];

                        }
                        
                        
                        
                    }else if ([[dict valueForKeyPath:@"data.roleid"] isEqualToString:@"2"]){
                        
                        //goto seller
                        [APP_WINDOW setRootViewController:[Utility createHomeTabbar]];
                        
                    }
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
