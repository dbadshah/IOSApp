//
//  CityCoveredVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 09/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "CityCoveredVC.h"
#import "CityCell.h"
#import "SearchCityVC.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "AppDelegate.h"
#import "WebServiceCall.h"
@interface CityCoveredVC ()

@end

@implementation CityCoveredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tblView.tableFooterView=viewFooter;
    tblView.tableHeaderView=viewHeader;
    
    NSArray *arrStoredCity =[[UserDefault valueForKey:@"selectedCities"] componentsSeparatedByString:@","];
    
    if (arrStoredCity.count>0) {
        self.arrCities =[[NSMutableArray alloc] initWithArray:arrStoredCity];
        
    }
    else{
        self.arrCities=[[NSMutableArray alloc] init];
    }
    
    
    [self updateCountLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrCities.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"PriceRangeCell";
    
    CityCell *cell = (CityCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CityCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }

    cell.lblTitle.text=[self.arrCities objectAtIndex:indexPath.row];
    
    cell.btnDelete.tag=indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
-(IBAction)addNewCity:(id)sender{
    
    if (self.arrCities.count>3) {
        return;
    }
    
    SearchCityVC *objSearchCityVC =[[SearchCityVC alloc] initWithNibName:@"SearchCityVC" bundle:nil];
    objSearchCityVC.delegate=self;
    [self.navigationController pushViewController:objSearchCityVC animated:true];
   
}
-(void)deleteRow:(UIButton *)btn{
    
    [self.arrCities removeObjectAtIndex:btn.tag];
    //    [tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    [tblView reloadData];
    [self updateCountLabel];
}
-(void)updateCountLabel{
    
    [lblLeftRanges setText:[NSString stringWithFormat:@"%u city left",4-self.arrCities.count]];
}

-(IBAction)goBack:(id)sender{
    
    if (self.arrCities.count<1) {
      //  [Utility showAlertWithTitle:@"Please select city" withMessage:nil];
        //return;
        [self.navigationController popViewControllerAnimated:true];
        
    }
    else{
     
        NSString *commaSepCities =[self.arrCities componentsJoinedByString:@","];
        
//        [UserDefault setValue:commaSepCities forKey:@"selectedCities"];
//        [UserDefault setBool:true forKey:@"CitiesCovered"];
//        [UserDefault synchronize];

        [self.view endEditing:true];
        if (![Utility isInternetConnected]) {
            
            [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
            return;
            
        }
        NSString *post = [NSString stringWithFormat: @"agentid=%@&token=%@&save_type=2&hidden_city_list=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),
                          STATIC_TOKEN,commaSepCities];
        
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
        
    }
}
-(void)selectWithCity:(NSString *)city{
    [self.arrCities addObject:city];
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.arrCities count]-1 inSection:0]];
    
    [tblView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
    [self updateCountLabel];
}

@end
