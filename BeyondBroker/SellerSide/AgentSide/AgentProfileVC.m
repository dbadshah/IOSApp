//
//  AgentProfileVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 22/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "AgentProfileVC.h"
#import "SelectProfileCell.h"
#import "HomeSpecializationVC.h"
#import "PriceRangeVC.h"
#import "CityCoveredVC.h"
#import "ZilloProfileVC.h"
#import "PhotoVideoVC.h"
#import "ServiceProvideVC.h"
#import "BrokerageVC.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"
#import "CreateProfileVC.h"
#import "LeadsAndListingsVC.h"
#import "TransactionHistoryVC.h"
#import "EmailSettingVC.h"
#import "StartUpVC.h"
#import "HelpAndContactUsVC.h"
#import "EditProfiteVC.h"
@interface AgentProfileVC ()

@end

@implementation AgentProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationController.navigationBar setHidden:true];
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];


}
-(void)viewWillAppear:(BOOL)animated{
    
    self.arrData =[[NSMutableArray alloc] initWithObjects:@"Cities Covered",@"Home Types",@"Zillow URL",@"Brokerage",@"Leads",@"Transaction History",@"Help/Contact Us",@"Email Settings",@"Logout", nil];
    
    
    [tblView reloadData];
}
- (IBAction)btnEditProfileClick:(id)sender {

    EditProfiteVC *objEditProfiteVC =[[EditProfiteVC alloc] initWithNibName:@"EditProfiteVC" bundle:nil];
    [self.navigationController pushViewController:objEditProfiteVC animated:true];
    
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
   
    return  60.0f;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tblView deselectRowAtIndexPath:indexPath animated:true];
   switch (indexPath.row) {
        case 0:
       {
           CityCoveredVC *objCityCoveredVC =[[CityCoveredVC alloc] initWithNibName:@"CityCoveredVC" bundle:nil];
           [self.navigationController pushViewController:objCityCoveredVC animated:true];
       }
       break;
       case 1:
        {
            HomeSpecializationVC *objHomeSpecVC =[[HomeSpecializationVC alloc] initWithNibName:@"HomeSpecializationVC" bundle:nil];
            [self.navigationController pushViewController:objHomeSpecVC animated:true];
        }
        break;
        case 2:
        {
            ZilloProfileVC *objZilloProfileVC =[[ZilloProfileVC alloc] initWithNibName:@"ZilloProfileVC" bundle:nil];
            [self.navigationController pushViewController:objZilloProfileVC animated:true];
        
        }
        break;
        case 3:
        {
            BrokerageVC *objBrokerageVC =[[BrokerageVC alloc] initWithNibName:@"BrokerageVC" bundle:nil];
            [self.navigationController pushViewController:objBrokerageVC animated:true];
        }
        break;
        case 4:
        {
            
            LeadsAndListingsVC *objLeadsAndListingsVC =[[LeadsAndListingsVC alloc] initWithNibName:@"LeadsAndListingsVC" bundle:nil];
            [self.navigationController pushViewController:objLeadsAndListingsVC animated:true];

        }
            break;
        case 5:
        {
           
           TransactionHistoryVC *objServiceProvideVC =[[TransactionHistoryVC alloc] initWithNibName:@"TransactionHistoryVC" bundle:nil];
           [self.navigationController pushViewController:objServiceProvideVC animated:true];
           
        }
            break;
        case 6:
        {
            HelpAndContactUsVC *objServiceProvideVC =[[HelpAndContactUsVC alloc] initWithNibName:@"HelpAndContactUsVC" bundle:nil];
            objServiceProvideVC.strTitle=@"Agent Help";
            [self.navigationController pushViewController:objServiceProvideVC animated:true];
            
        }
        break;
        case 7:
        {

            EmailSettingVC *objEmailSettingVC =[[EmailSettingVC alloc] initWithNibName:@"EmailSettingVC" bundle:nil];
            [self.navigationController pushViewController:objEmailSettingVC animated:true];
        
        }
            break;
       case 8:
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
