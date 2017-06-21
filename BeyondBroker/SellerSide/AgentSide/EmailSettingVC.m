//
//  EmailSettingVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 22/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "EmailSettingVC.h"
#import "Utility.h"
#import "EmailCell.h"
@interface EmailSettingVC ()

@end

@implementation EmailSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


}
-(void)viewWillAppear:(BOOL)animated{
    
    [UserDefault setBool:true forKey:@"ismsgnofication"];
    
    self.arrData =[[NSMutableArray alloc] initWithObjects:@"Message notifications",@"Account activity",@"General & Marketing Emails", nil];
    self.arrDescrption=[[NSMutableArray alloc] initWithObjects:@"Notifications when a seller messages.",@"Analysis confirmations, review activity, and security alerts. These are required to service your account. You may not opt out of these notices.",@"General promotions, updates, news about Beyond Broker or general promotions for partner campaigns and services, user surveys, inspiration, and love from Beyond Broker.", nil];
 
    self.arrCompleteFlag =[[NSMutableArray alloc] initWithObjects:
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"ismsgnofication"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isaccountactivity"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isgeneral"]],
                           nil];
    
   
    tblView.rowHeight = UITableViewAutomaticDimension;
    tblView.estimatedRowHeight = 110;

    [tblView reloadData];
    
}
-(IBAction)goBack:(id)sender{
//    
//    if (![UserDefault boolForKey:@"ismsgnofication"]) {
//        
//        if (![UserDefault boolForKey:@"isProvidefullservice"]) {
//            
//            [Utility showAlertWithTitle:@"Please select any one." withMessage:nil];
//            return;
//        }
//    }
//    
    
    [self.navigationController popViewControllerAnimated:true];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"EmailCell";
    
    EmailCell *cell = (EmailCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
     cell.lblTitle.text=[self.arrData objectAtIndex:indexPath.row];
     cell.lblDescrption.text=[self.arrDescrption objectAtIndex:indexPath.row];
    
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
    
    if (indexPath.row==0) {
        
        return  90.0f;

    }else if (indexPath.row==1){
        
        return  110.0f;
    
    }else{
        
     return  130.0f;
 
        
    }
   

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tblView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:
        {
           
            if ([UserDefault boolForKey:@"ismsgnofication"]) {
                
              
                [UserDefault setBool:false forKey:@"ismsgnofication"];
                
            }else{
                
                [UserDefault setBool:true forKey:@"ismsgnofication"];
                
            }
            
        }
        break;
        case 1:
        {
            if ([UserDefault boolForKey:@"isaccountactivity"]) {
                
            
                [UserDefault setBool:false forKey:@"isaccountactivity"];
                
           }else{
                
                [UserDefault setBool:true forKey:@"isaccountactivity"];
                
            }
       
        }
            break;
        case 2:
        {
            if ([UserDefault boolForKey:@"isgeneral"]) {
                
                [UserDefault setBool:false forKey:@"isgeneral"];
                
            }else{
                
                [UserDefault setBool:true forKey:@"isgeneral"];
                
            }
        }
           
            break;
            default:
            break;
    }

    self.arrCompleteFlag =[[NSMutableArray alloc] initWithObjects:
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"ismsgnofication"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isaccountactivity"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isgeneral"]],
                           nil];
    [tableView reloadData];

}
@end
