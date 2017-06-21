//
//  ThankSubmissionVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 15/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ThankSubmissionVC.h"
#import "ListingsVC.h"
@interface ThankSubmissionVC ()

@end

@implementation ThankSubmissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingle:)];
    [self.ViewDashboard addGestureRecognizer:singleFingerTap];

}
-(void)handleSingle:(UITapGestureRecognizer *)recognizer
{
    ListingsVC *objListingsVC =[[ListingsVC alloc] initWithNibName:@"ListingsVC" bundle:nil];
    [self.navigationController pushViewController:objListingsVC animated:true];
}
@end
