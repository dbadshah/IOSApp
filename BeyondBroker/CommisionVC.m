//
//  CommisionVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 17/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "CommisionVC.h"
#import "CommissionCell.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "AppDelegate.h"
#import "WebServiceCall.h"

@interface CommisionVC ()

@end

@implementation CommisionVC

- (void)viewDidLoad {
    [super viewDidLoad];
   


}
-(void)viewWillAppear:(BOOL)animated{
    self.arrData =[[NSMutableArray alloc] initWithObjects:@"5-6% (Provides full service)",@"3-4% (Provides limited services)", nil];
    
    NSArray *arrSelectedHomeTypes =[[UserDefault valueForKey:@"Commissionid"] componentsSeparatedByString:@","];
    self.arrSelectedId =[[NSMutableArray alloc] initWithArray:arrSelectedHomeTypes];
    
    for (int i = 0; i < [self.arrSelectedId count]; i++)
    {
        
        NSString *selectid=[NSString stringWithFormat:@"%@",[self.arrSelectedId objectAtIndex:i]];
        if ([selectid isEqualToString:@"1"]) {
            
         [UserDefault setBool:true forKey:@"isProvidefullservice"];
            
        }else if ([selectid isEqualToString:@"2"]){
            
         [UserDefault setBool:true forKey:@"isProvideslimitedservices"];
       
        }else{
            
          [UserDefault setBool:true forKey:@"isProvidefullservice"];
            
        }
    }
    
    self.arrCompleteFlag =[[NSMutableArray alloc] initWithObjects:
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isProvidefullservice"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isProvideslimitedservices"]],
                            nil];
    
    tblView.tableFooterView=self.footerView;
    [tblView reloadData];
    
}
-(IBAction)goBack:(id)sender{
    
    NSString *commissonstr;
    
    if (![UserDefault boolForKey:@"isProvideslimitedservices"]) {
        
        if (![UserDefault boolForKey:@"isProvidefullservice"]) {
            
            [Utility showAlertWithTitle:@"Please select commission" withMessage:nil];
            return;
        }
    }
    
    if ([UserDefault boolForKey:@"isProvidefullservice"]) {
        
        commissonstr=[NSString stringWithFormat:@"1"];
      
        if ([UserDefault boolForKey:@"isProvideslimitedservices"]) {
            
             commissonstr=[NSString stringWithFormat:@"1,2"];
        }
    
    }else{
        
        commissonstr=[NSString stringWithFormat:@"2"];
    
    }
    
//    [UserDefault setValue:commissonstr forKey:@"Commissionid"];
    
    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    NSString *post = [NSString stringWithFormat: @"agentid=%@&token=%@&save_type=10&agent_commission=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),
                      STATIC_TOKEN,commissonstr];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_finish_account"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                NSLog(@"%@",dict);
                [self.navigationController popViewControllerAnimated:true];
                
            }else{
                
                [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                return;
            }
        }else{
            
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
    
    //[UserDefault setBool:true forKey:@"Commission"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"CommissionCell";
    
    CommissionCell *cell = (CommissionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommissionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblTitle.text=[self.arrData objectAtIndex:indexPath.row];
    if ([[self.arrCompleteFlag objectAtIndex:indexPath.row] boolValue]) {
        
        cell.lblTitle.textColor =[UIColor grayColor];
        [cell.imgViewCheck setImage:[UIImage imageNamed:@"checked.png"]];
    }
    else{
        cell.lblTitle.textColor =[Utility getColor:TEXT_COLOR];
        [cell.imgViewCheck setImage:[UIImage imageNamed:@"unchecked.png"]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return  40.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tblView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:
        {
            if ([UserDefault boolForKey:@"isProvidefullservice"]) {
                
                [UserDefault setBool:false forKey:@"isProvidefullservice"];
                
            }else{
                
                [UserDefault setBool:true forKey:@"isProvidefullservice"];
            
            }
        }
        break;
        case 1:
        {
            if ([UserDefault boolForKey:@"isProvideslimitedservices"]) {
                
                [UserDefault setBool:false forKey:@"isProvideslimitedservices"];
            
            }else{
                
                [UserDefault setBool:true forKey:@"isProvideslimitedservices"];
            }
        }
        break;
        
        default:
        break;
    }
    
    self.arrCompleteFlag =[[NSMutableArray alloc] initWithObjects:
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isProvidefullservice"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isProvideslimitedservices"]],
                           nil];
    
    [tableView reloadData];

}
@end
