//
//  LeadsAndListingsVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 16/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "LeadsAndListingsVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
@interface LeadsAndListingsVC ()

@end

@implementation LeadsAndListingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    viewLeads.layer.cornerRadius=2.0f;
    viewLeads.layer.borderColor=[UIColor grayColor].CGColor;
    viewLeads.layer.borderWidth=1.0f;
    viewLeads.layer.masksToBounds=true;
    
    btnLeadMinus.layer.cornerRadius=2.0f;
    btnLeadMinus.layer.borderColor=[UIColor grayColor].CGColor;
    btnLeadMinus.layer.borderWidth=1.0f;
    btnLeadMinus.layer.masksToBounds=true;
    
    btnLeadPlus.layer.cornerRadius=2.0f;
    btnLeadPlus.layer.borderColor=[UIColor grayColor].CGColor;
    btnLeadPlus.layer.borderWidth=1.0f;
    btnLeadPlus.layer.masksToBounds=true;
    
    viewListing.layer.cornerRadius=2.0f;
    viewListing.layer.borderColor=[UIColor grayColor].CGColor;
    viewListing.layer.borderWidth=1.0f;
    viewListing.layer.masksToBounds=true;
    
    btnListingMinus.layer.cornerRadius=2.0f;
    btnListingMinus.layer.borderColor=[UIColor grayColor].CGColor;
    btnListingMinus.layer.borderWidth=1.0f;
    btnListingMinus.layer.masksToBounds=true;
    
    btnListingPlus.layer.cornerRadius=2.0f;
    btnListingPlus.layer.borderColor=[UIColor grayColor].CGColor;
    btnListingPlus.layer.borderWidth=1.0f;
    btnListingPlus.layer.masksToBounds=true;
    
    lblLeads.text=[UserDefault valueForKey:@"selectedLeads"];
    lblListings.text=[UserDefault valueForKey:@"selectedListings"];

}
-(IBAction)goBack:(id)sender{
    
    [UserDefault setValue:lblLeads.text forKey:@"selectedLeads"];
    [UserDefault setObject:@"3" forKey:@"amountPerLead"];
    
    [UserDefault setValue:lblListings.text forKey:@"selectedListings"];
    [UserDefault setObject:@"50" forKey:@"amountPerListing"];
    
    
    [UserDefault setBool:true forKey:@"isLeadsAndListings"];
    [UserDefault synchronize];
    
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)increaseDecreaseLeads:(UIButton *)btn{
    
    if (btn.tag==1) {
        
        if ([lblLeads.text integerValue]<=1) {
         
            return;
        }
        
        lblLeads.text=[NSString stringWithFormat:@"%d",[lblLeads.text integerValue]-1];
    }
    else{
        lblLeads.text=[NSString stringWithFormat:@"%d",[lblLeads.text integerValue]+1];

    }
    
}
-(IBAction)increaseDecreaseListings:(UIButton *)btn{
    
    if (btn.tag==3) {
        
        if ([lblListings.text integerValue]<=1) {
            
            return;
        }
        
        lblListings.text=[NSString stringWithFormat:@"%d",[lblListings.text integerValue]-1];
    }
    else{
        lblListings.text=[NSString stringWithFormat:@"%d",[lblListings.text integerValue]+1];
        
    }
    
    
}


@end
