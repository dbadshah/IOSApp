//
//  BrokerageVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "BrokerageVC.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "WebServiceCall.h"

@interface BrokerageVC ()

@end

@implementation BrokerageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    viewBrokerage.layer.cornerRadius=2.0f;
    viewBrokerage.layer.borderColor=[UIColor grayColor].CGColor;
    viewBrokerage.layer.borderWidth=1.0f;
    viewBrokerage.layer.masksToBounds=true;
    
    viewAdd1.layer.cornerRadius=2.0f;
    viewAdd1.layer.borderColor=[UIColor grayColor].CGColor;
    viewAdd1.layer.borderWidth=1.0f;
    viewAdd1.layer.masksToBounds=true;
    
    viewAdd2.layer.cornerRadius=2.0f;
    viewAdd2.layer.borderColor=[UIColor grayColor].CGColor;
    viewAdd2.layer.borderWidth=1.0f;
    viewAdd2.layer.masksToBounds=true;
    
    viewAdd3.layer.cornerRadius=2.0f;
    viewAdd3.layer.borderColor=[UIColor grayColor].CGColor;
    viewAdd3.layer.borderWidth=1.0f;
    viewAdd3.layer.masksToBounds=true;
    
    viewAdd4.layer.cornerRadius=2.0f;
    viewAdd4.layer.borderColor=[UIColor grayColor].CGColor;
    viewAdd4.layer.borderWidth=1.0f;
    viewAdd4.layer.masksToBounds=true;
    
    viewPhone.layer.cornerRadius=2.0f;
    viewPhone.layer.borderColor=[UIColor grayColor].CGColor;
    viewPhone.layer.borderWidth=1.0f;
    viewPhone.layer.masksToBounds=true;

    txtBfirm.text=[UserDefault valueForKey:@"BrokerageFirm"];;
    txtAdd.text=[UserDefault valueForKey:@"BrokerageAddress"];
    txtLandmark.text=[UserDefault valueForKey:@"BrokerageLandmark"];
    txtPincode.text=[UserDefault valueForKey:@"BrokeragePinCode"];
    txtPhone.text=[UserDefault valueForKey:@"BrokeragePhone"];

}
-(IBAction)goBack:(id)sender{
    
     int length = (int)[self getLength:txtPhone.text];
    if(txtBfirm.text.length<1)
    {
        [Utility showAlertWithTitle:@"Please enter firm" withMessage:nil];
        return;
    }
   else if (txtAdd.text.length<1) {
        [Utility showAlertWithTitle:@"Please enter address" withMessage:nil];
        return;
    }
    else if (txtLandmark.text.length<1)
    {
        [Utility showAlertWithTitle:@"Please enter landmark" withMessage:nil];
        return;
    }
    else if (txtPincode.text.length<1)
    {
        [Utility showAlertWithTitle:@"Please enter pincode" withMessage:nil];
        return;
        
    }
    else if (length < 10)
    {
        [Utility showAlertWithTitle:@"Please enter phone number" withMessage:nil];
        return;
    }

    
    
//    [UserDefault setValue:txtBfirm.text forKey:@"BrokerageFirm"];
//    [UserDefault setValue:txtAdd.text forKey:@"BrokerageAddress"];
//    [UserDefault setValue:txtLandmark.text forKey:@"BrokerageLandmark"];
//    [UserDefault setValue:@"WA" forKey:@"BrokerageState"];
//    [UserDefault setValue:txtPincode.text forKey:@"BrokeragePinCode"];

    NSString *mobile= [UserDefault valueForKey:@"BrokeragePhone"];
    
    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    NSString *post = [NSString stringWithFormat: @"agentid=%@&token=%@&save_type=5&brokerage_firm=%@&brach_address=%@&branch_city=%@&branch_state=WA&branch_zipcode=%@&branch_phone=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),
            STATIC_TOKEN,txtBfirm.text,txtAdd.text,txtLandmark.text,txtPincode.text,mobile];
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtPhone) {
        int length = (int)[self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            //NSLog(@"%@",[num  substringToIndex:3]);
            //NSLog(@"%@",[num substringFromIndex:3]);
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
        
        return YES;
   
    }
        return YES;
 }
- (NSString *)formatNumber:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    return mobileNumber;
}
- (int)getLength:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    [UserDefault setValue:mobileNumber forKey:@"BrokeragePhone"];
    return length;
}
@end
