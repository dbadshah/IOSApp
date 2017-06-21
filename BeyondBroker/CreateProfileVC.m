//
//  CreateProfileVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 06/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "CreateProfileVC.h"
#import "SelectProfileVC.h"
#import "WebServiceCall.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "FinishAccountVC.h"
@interface CreateProfileVC ()

@end

@implementation CreateProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnContinue.layer.cornerRadius=5.0;
    
    [self performSelector:@selector(checkForProfileCompletion) withObject:nil afterDelay:0.5];
    
    [btnFinish setHidden:true];
    [btnContinue setHidden:true];
    [lblApprove setHidden:true];
    [lblProfile setHidden:true];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:true];
    
}
-(IBAction)selectProfile:(id)sender{

    SelectProfileVC *objSelectProfileVC =[[SelectProfileVC alloc] initWithNibName:@"SelectProfileVC" bundle:nil];
    [self.navigationController pushViewController:objSelectProfileVC animated:true];
    
}
-(void)checkForProfileCompletion{
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    NSString *post = [NSString stringWithFormat: @"agentid=%@&token=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_verify"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                if ([[dict valueForKey:@"isagent_profile"] isEqualToString:@"0"]) {
                    
                    [btnContinue setHidden:false];
                    [btnFinish setHidden:true];
                    [lblProfile setHidden:true];
                    [lblApprove setHidden:true];
                    
                }
                else if ([[dict valueForKey:@"isagent_profile"] isEqualToString:@"1"])
                {
                    [btnContinue setHidden:true];
                    [btnFinish setHidden:true];
                    [lblProfile setHidden:false];
                    [lblApprove setHidden:false];
                    
                    lblProfile.text=@"complete";
                    lblApprove.text=@"waiting list";
                    
                    [lblProfile setTextColor:[Utility getColor:GREEN_COLOR]];
                    [lblApprove setTextColor:[Utility getColor:ORANGE_COLOR]];
                }
                else if ([[dict valueForKey:@"isagent_profile"] isEqualToString:@"2"])
                {
                    
                    [btnContinue setHidden:true];
                    [btnFinish setHidden:false];
                    [lblProfile setHidden:false];
                    [lblApprove setHidden:false];
                    
                    lblProfile.text=@"complete";
                    lblApprove.text=@"complete";
                    
                    [lblProfile setTextColor:[Utility getColor:GREEN_COLOR]];
                    [lblApprove setTextColor:[Utility getColor:GREEN_COLOR]];
                }
                
                
            }
            else if([[dict valueForKey:@"status"] integerValue]==2)
            {
                
                
            
                
                
                
            }
            else if([[dict valueForKey:@"status"] integerValue]==3)
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

-(IBAction)gotoFinishAccount:(id)sender{
    
    FinishAccountVC *objFinishAccountVC =[[FinishAccountVC alloc] initWithNibName:@"FinishAccountVC" bundle:nil];
    [self.navigationController pushViewController:objFinishAccountVC animated:true];
    
}
@end
