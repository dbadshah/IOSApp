//
//  PhotoHomeVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 19/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "PhotoHomeVC.h"
#import "Utility.h"
#import "CaptureImageVC.h"
#import "DataManager.h"
@interface PhotoHomeVC ()

@end

@implementation PhotoHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
 NSString *limit = [NSString stringWithFormat:@"%@", [DATA_MANAGER getAllRoomLimit]];
 _lblLimitcount.text=CHECK_NULL_STRING(limit);
    

}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)btnGetStartedClick:(id)sender {
    
    CaptureImageVC *objCaptureImageVC =[[CaptureImageVC alloc] initWithNibName:@"CaptureImageVC" bundle:nil];
    [self.navigationController pushViewController:objCaptureImageVC animated:true];
    
}
@end
