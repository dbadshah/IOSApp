//
//  AgentDetailVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 19/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "AgentDetailVC.h"

@interface AgentDetailVC ()

@end

@implementation AgentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    txtView.editable=NO;
    txtView.text=self.Text;
    self.lblNavTitle.text=self.Title;
    
}
- (IBAction)btnbackClick:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}
@end
