//
//  ZilloProfileVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ZilloProfileVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "AppDelegate.h"
#import "WebServiceCall.h"
@interface ZilloProfileVC ()

@end

@implementation ZilloProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    txtZelloProfile.text=[UserDefault valueForKey:@"strZilloProfile"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender{
    
    if (txtZelloProfile.text.length<1) {
        [Utility showAlertWithTitle:@"Please enter zillo profile name" withMessage:nil];
        return;
    }
    
//    [UserDefault setValue:txtZelloProfile.text forKey:@"strZilloProfile"];
//    [UserDefault setBool:true forKey:@"ZilloProfile"];
//    [UserDefault synchronize];
//    
//    [self.navigationController popViewControllerAnimated:true];

    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    NSString *post = [NSString stringWithFormat: @"agentid=%@&token=%@&save_type=4&zillow_profile_name=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),
                      STATIC_TOKEN,txtZelloProfile.text];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_finish_account"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                NSLog(@"%@",dict);
                [self.navigationController popViewControllerAnimated:true];
                
            }else{
                
                [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                return;
            }
        }else{
            
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
    

}
@end
