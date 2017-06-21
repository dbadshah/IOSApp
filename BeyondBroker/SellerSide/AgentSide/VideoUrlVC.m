//
//  VideoUrlVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "VideoUrlVC.h"
#import "WebServiceCall.h"
#import "Utility.h"
@interface VideoUrlVC ()

@end

@implementation VideoUrlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


}
-(IBAction)goBack:(id)sender{
    
    if (txtField.text.length<1) {
        [Utility showAlertWithTitle:@"Please enter video url." withMessage:nil];
        return;
    }
   
    [UserDefault setValue:txtField.text forKey:@"videourleditprofile"];
    [UserDefault synchronize];
    [self.navigationController popViewControllerAnimated:true];
}
@end
