//
//  ProfileVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 18/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ProfileVC.h"
#import "WebServiceCall.h"
#import "Utility.h"
#import "SelectProfileCell.h"
#import "StartUpVC.h"
#import "AppDelegate.h"
#import "EmailSettingVC.h"
#import "HelpAndContactUsVC.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationController.navigationBar setHidden:true];
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    ////firstName,lastName
    
    NSString *firstname=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"firstName"]];
    NSString *lastName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"lastName"]];
    lblUserName.text=[NSString stringWithFormat:@"%@ %@",CHECK_NULL_STRING(firstname),CHECK_NULL_STRING(lastName)];
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.arrData =[[NSMutableArray alloc] initWithObjects:@"Help/Contact Us",@"Terms & Conditions",@"Email Settings",@"Logout", nil];
   
    tblView.tableFooterView=[UIView new];
    
    [tblView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SelectProfileCell";
    
    SelectProfileCell *cell = (SelectProfileCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectProfileCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.lblTitle.text=[self.arrData objectAtIndex:indexPath.row];
    cell.lblTitle.textColor=[Utility getColor:TEXT_COLOR];
    cell.imgViewCheck.hidden=YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  50.0f;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tblView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:
        {
            HelpAndContactUsVC *objServiceProvideVC =[[HelpAndContactUsVC alloc] initWithNibName:@"HelpAndContactUsVC" bundle:nil];
            objServiceProvideVC.strTitle=@"Seller Help";
            [self.navigationController pushViewController:objServiceProvideVC animated:true];

        }
        break;
        case 1:
        {
           
        
        }
        break;
        case 2:
        {
            EmailSettingVC *objEmailSettingVC =[[EmailSettingVC alloc] initWithNibName:@"EmailSettingVC" bundle:nil];
            [self.navigationController pushViewController:objEmailSettingVC animated:true];
        
        }
        break;
        case 3:
        {
            [Utility removeAllUserDefaults];
            StartUpVC *objStartUpVC =[[StartUpVC alloc] initWithNibName:@"StartUpVC" bundle:nil];
            UINavigationController *objNavcontroller =[[UINavigationController alloc] initWithRootViewController:objStartUpVC];
            [APP_WINDOW setRootViewController:objNavcontroller];
            [APP_WINDOW makeKeyAndVisible] ;
        }
        break;
        default:
        break;
    }
}

@end
