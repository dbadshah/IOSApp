//
//  IntroDetailVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 14/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "IntroDetailVC.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "WebServiceCall.h"
@interface IntroDetailVC ()

@end

@implementation IntroDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch (self.optionSelected) {
        case 0:
        {
            navTitle.text=@"Quick intro";
            
            NSString *quickIntro =[UserDefault valueForKey:@"quickIntro"];
            if (quickIntro.length>0) {
                txtView.text=quickIntro;
            }
            else{
                txtView.placeholder=@"Create an intro. This will be the first thing sellers see.";
            }
            lblCharCount.text=[NSString stringWithFormat:@"%u characters left",300-txtView.text.length];

        }
        break;
        case 1:
        {
            navTitle.text=@"Experience and education";
            
            NSString *expAndEdu =[UserDefault valueForKey:@"expAndEdu"];
            if (expAndEdu.length>0) {
                txtView.text=expAndEdu;
            }
            else{
                txtView.placeholder=@"Tell sellers about your experience and education";
            }
            lblCharCount.text=[NSString stringWithFormat:@"%u characters left",600-txtView.text.length];

        }
            break;
        case 2:
        {
            navTitle.text=@"Fun facts about you";
            NSString *funAndFacts =[UserDefault valueForKey:@"funAndFact"];
            if (funAndFacts.length>0) {
                txtView.text=funAndFacts;
            }
            else{
                txtView.placeholder=@"Give some fun facts about your self";
            }
            
            lblCharCount.text=[NSString stringWithFormat:@"%u characters left",300-txtView.text.length];

        }
            break;
        case 3:
        {
            navTitle.text=@"Interesting Things About Me";
            NSString *funAndFacts =[UserDefault valueForKey:@"aboutme"];
            if (funAndFacts.length>0) {
            
                txtView.text=funAndFacts;
            
            }else{
               
                txtView.placeholder=@"Interesting Things About Me";
            }
            
            lblCharCount.text=[NSString stringWithFormat:@"%u characters left",300-txtView.text.length];
            
        }
            break;
        default:
            break;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSInteger totalCharacter;
    

    
    switch (self.optionSelected) {
        case 0:
        {
            totalCharacter=300;
            if ((textView.text.length>300) && (range.length==0)) {
                return false;
            }
        }
        break;
        case 1:
        {
            totalCharacter=600;
            if ((textView.text.length>600) && (range.length==0)) {
                return false;
            }
        }
            break;
        case 2:
        {
            totalCharacter=300;
            if ((textView.text.length>300) && (range.length==0)) {
                return false;
            }
        }
            break;
        case 3:
        {
            totalCharacter=300;
            if ((textView.text.length>300) && (range.length==0)) {
                return false;
            }
        }
            break;
        default:
            return true;
            break;
    }
    
    
    lblCharCount.text=[NSString stringWithFormat:@"%u characters left",totalCharacter-txtView.text.length];
    
    return true;
}
-(IBAction)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)saveBtnClick:(id)sender{
   
    NSString *post;
    
    if (txtView.text.length<1) {
    
        [Utility showAlertWithTitle:@"Please enter value" withMessage:nil];
        return;
        
    }
    switch (self.optionSelected) {
        case 0:
        {
            
            post = [NSString stringWithFormat:@"agentid=%@&token=%@&save_type=6&quick_intro=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),
                              STATIC_TOKEN,txtView.text];
            
        }
        break;
        case 1:
        {
        
           post = [NSString stringWithFormat:@"agentid=%@&token=%@&save_type=7&education=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),
                              STATIC_TOKEN,txtView.text];
        }
        break;
        case 2:
        {
            post = [NSString stringWithFormat:@"agentid=%@&token=%@&save_type=8&aboutme=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]), STATIC_TOKEN,txtView.text];
            
        }
        case 3:
        {
            [UserDefault setValue:txtView.text forKey:@"aboutme"];
            [UserDefault setBool:true forKey:@"isaboutme"];
        }
        break;
        default:
        break;
    }
   
    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
    }
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_finish_account"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                switch (self.optionSelected) {
                    case 0:
                    {
                      
                        [UserDefault setValue:txtView.text forKey:@"quickIntro"];
                        [UserDefault setBool:true forKey:@"isQuickIntro"];
                        [self.navigationController popViewControllerAnimated:true];
                    
                    }
                    break;
                    case 1:
                    {
                      
                        [UserDefault setValue:txtView.text forKey:@"expAndEdu"];
                        [UserDefault setBool:true forKey:@"isExpAndEdu"];
                        [self.navigationController popViewControllerAnimated:true];
                    
                    }
                    break;
                    case 2:
                    {
                        [UserDefault setValue:txtView.text forKey:@"funAndFact"];
                        [UserDefault setBool:true forKey:@"isFunAndFact"];
                        [self.navigationController popViewControllerAnimated:true];
                    
                    }
                    break;
                    case 3:
                    {
                        
                         [self.navigationController popViewControllerAnimated:true];
                   
                    }
                    break;
                    default:
                    break;
                }
                
                }else{
                
                [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                return;
            }
        }else{
            
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];

    //[UserDefault synchronize];
    //[self.navigationController popViewControllerAnimated:true];
}
@end
