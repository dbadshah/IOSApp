//
//  AgentLookVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 19/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "AgentLookVC.h"
#import "PhotoHomeVC.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"
@interface AgentLookVC ()

@end

@implementation AgentLookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [UserDefault setObject:@"1" forKey:KIND_OF_AGENT];

}
-(IBAction)onRadioBtn:(RadioButton*)sender
{
     NSString *selectValue = [NSString stringWithFormat:@"%ld", (long)sender.tag];
     [UserDefault setObject:selectValue forKey:KIND_OF_AGENT];

}
-(IBAction)btnBackClick:(id)sender {

  [self.navigationController popViewControllerAnimated:YES];

}
-(IBAction)btnNextClick:(id)sender {

   
}

@end
