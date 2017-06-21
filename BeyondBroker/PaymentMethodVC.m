//
//  PaymentMethodVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 16/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "PaymentMethodVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
@interface PaymentMethodVC ()

@end

@implementation PaymentMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    viewCreditCard.layer.cornerRadius=2.0f;
    viewCreditCard.layer.borderColor=[UIColor grayColor].CGColor;
    viewCreditCard.layer.borderWidth=1.0f;
    viewCreditCard.layer.masksToBounds=true;
    
    viewExpDate.layer.cornerRadius=2.0f;
    viewExpDate.layer.borderColor=[UIColor grayColor].CGColor;
    viewExpDate.layer.borderWidth=1.0f;
    viewExpDate.layer.masksToBounds=true;
    
    viewSecurityCode.layer.cornerRadius=2.0f;
    viewSecurityCode.layer.borderColor=[UIColor grayColor].CGColor;
    viewSecurityCode.layer.borderWidth=1.0f;
    viewSecurityCode.layer.masksToBounds=true;
    
    
    txtCreditCard.text=[UserDefault valueForKey:@"CreditCardNumber"];
    txtExpDate.text=[UserDefault valueForKey:@"expireDate"];
    txtSecurityCode.text=[UserDefault valueForKey:@"securityCode"];
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(IBAction)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:true];
}


-(IBAction)save:(id)sender{
    
    [self.view endEditing:true];
    
    if (txtCreditCard.text.length<1) {
        [Utility showAlertWithTitle:@"Please enter credit card number." withMessage:nil];
        
        return;
    }
    else if (txtExpDate.text.length<1)
    {
        [Utility showAlertWithTitle:@"Please enter expire date." withMessage:nil];
        return;
    }
    else if (txtSecurityCode.text.length<1)
    {
        [Utility showAlertWithTitle:@"Please enter security code" withMessage:nil];
        return;
        
    }
    
    
    [UserDefault setValue:CHECK_NULL_STRING(txtCreditCard.text) forKey:@"CreditCardNumber"];
    [UserDefault setValue:CHECK_NULL_STRING(txtExpDate.text) forKey:@"expireDate"];
    [UserDefault setValue:CHECK_NULL_STRING(txtSecurityCode.text) forKey:@"securityCode"];
    
    [UserDefault setBool:true forKey:@"isPaymentMethod"];
    [UserDefault synchronize];
    
    
    
    
    [self.navigationController popViewControllerAnimated:true];
}

@end
