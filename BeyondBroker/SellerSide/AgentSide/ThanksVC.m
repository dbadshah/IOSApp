//
//  ThanksVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 29/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ThanksVC.h"

@interface ThanksVC ()

@end

@implementation ThanksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

-(IBAction)btnProfileClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
