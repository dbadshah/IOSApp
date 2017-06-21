//
//  SearchCityVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "SearchCityVC.h"
#import "AddCityCell.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "CityDetail.h"
@interface SearchCityVC ()

@end

@implementation SearchCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tblView.tableFooterView=[UIView new];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CityDetail *CityObj =[self.arrData objectAtIndex:indexPath.row];
    
    static NSString *simpleTableIdentifier = @"AddCityCellId";
    
    AddCityCell *cell = (AddCityCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddCityCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    if (CityObj.waitlist.integerValue == 1) {
        
       cell.lblTitle.text=[NSString stringWithFormat:@"%@, %@ (waitlist)",CityObj.city, CityObj.state];
    
    }else{
        
        cell.lblTitle.text=[NSString stringWithFormat:@"%@, %@",CityObj.city, CityObj.state];

    }
    
    cell.btnAdd.tag=indexPath.row;
    [cell.btnAdd addTarget:self action:@selector(addCity:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50.0f;
}
-(void)addCity:(UIButton *)btn{
    
    CityDetail *CityObj =[self.arrData objectAtIndex:btn.tag];
    [self.delegate selectWithCity:CityObj.city];
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:true];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar.text.length>3) {
        
        [self searchCityByText:searchBar.text];
    }
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [objSearchBar resignFirstResponder];
    
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //This'll Show The cancelButton with Animation
    [searchBar setShowsCancelButton:YES animated:YES];
    //remaining Code'll go here
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //This'll Hide The cancelButton with Animation
    [objSearchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    //remaining Code'll go here
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}
-(void)searchCityByText:(NSString *)text{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    NSString *post = [NSString stringWithFormat: @"token=%@&term=%@",STATIC_TOKEN,text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_city_list"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                self.arrData=[[NSMutableArray alloc]init];
                for (NSDictionary *dictData in [dict valueForKey:@"data"]) {
                    
                    CityDetail *CityObj = [[CityDetail alloc] init];
                    CityObj.city =  CHECK_NULL_STRING([dictData valueForKey:@"city"]);
                    CityObj.state = CHECK_NULL_STRING([dictData valueForKey:@"state"]);
                    CityObj.waitlist = [dictData valueForKey:@"waitlist"];
                    [self.arrData addObject:CityObj];
                }
               
                [tblView reloadData];
                
            }
            else{
                
                self.arrData=[[NSMutableArray alloc]init];
                [tblView reloadData];
               // [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                return;
            }
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
    
}
@end
