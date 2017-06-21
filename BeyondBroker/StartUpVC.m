//
//  StartUpVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 05/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "StartUpVC.h"
#import <QuartzCore/QuartzCore.h>
#import "RegistrationVC.h"
#import "LoginVC.h"
#import "SelectProfileVC.h"
@interface StartUpVC ()

@end

@implementation StartUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnLogin.layer.cornerRadius = 5.0;
    btnSignUp.layer.cornerRadius = 5.0;
    
    lblOneLiner.adjustsFontSizeToFitWidth=true;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:true];
}
-(IBAction)signUpBtnClick:(id)sender{

    RegistrationVC *objRegistration =[[RegistrationVC alloc] initWithNibName:@"RegistrationVC" bundle:nil];
    [self.navigationController pushViewController:objRegistration animated:true];
    
}
-(IBAction)gotoLoginScreen:(id)sender{

    LoginVC *objLoginVC =[[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:objLoginVC animated:true];
    
  /*  SelectProfileVC *objSelectProf =[[SelectProfileVC alloc] initWithNibName:@"SelectProfileVC" bundle:nil];
    [self.navigationController pushViewController:objSelectProf animated:true];*/
    
}
@end
