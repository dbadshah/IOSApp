//
//  PhotoExmpleVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 01/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "PhotoExmpleVC.h"

@interface PhotoExmpleVC ()

@end

@implementation PhotoExmpleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}
- (IBAction)btnBackClick:(id)sender {
  
    [self.navigationController popViewControllerAnimated:true];

}

@end
