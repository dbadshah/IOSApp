//
//  PriceRangeVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 08/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "PriceRangeVC.h"
#import "PriceRangeCell.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "WebServiceCall.h"
@interface PriceRangeVC ()

@end

@implementation PriceRangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any  additional setup after loading the view from its nib.
    tblView.tableFooterView=viewFooter;
    tblView.tableHeaderView=viewHeader;
    [self updateCountLabel];
    
    [self performSelector:@selector(getPriceRangesFromServer) withObject:nil afterDelay:0.1];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrPriceRange.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"PriceRangeCell";
    
    PriceRangeCell *cell = (PriceRangeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PriceRangeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    NSDictionary *dict =[self.arrPriceRange objectAtIndex:indexPath.row];
    
    [cell.btnPriceRange setTitle:[dict valueForKey:@"pricerange"] forState:UIControlStateNormal];
    cell.btnDelete.tag=indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnPriceRange.tag=indexPath.row;
    [cell.btnPriceRange addTarget:self action:@selector(showDropdown:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
-(IBAction)addNewPriceRange:(id)sender{
    
    if (self.arrPriceRange.count>3) {
        return;
    }
    
    if (self.dictFirstObject==nil) {
        [self performSelector:@selector(getPriceRangesFromServer) withObject:nil afterDelay:0.1];

    }
    else{
        [self.arrPriceRange addObject:self.dictFirstObject];
        NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.arrPriceRange count]-1 inSection:0]];
        
        [tblView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
        [self updateCountLabel];
    }
    
    
    
}
-(void)deleteRow:(UIButton *)btn{
    
    [self.arrPriceRange removeObjectAtIndex:btn.tag];
//    [tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tblView reloadData];
    [self updateCountLabel];
}
-(void)showDropdown:(UIButton *)btn{
    
    selectedRow= btn.tag;
    actSheetValues=[[UIActionSheet alloc] initWithTitle:@"select price ranges" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for (NSDictionary *dict in self.arrDropDownVal) {
        [actSheetValues addButtonWithTitle:[dict valueForKey:@"pricerange"]];
        
    }
    [actSheetValues addButtonWithTitle:@"Cancel"];
    actSheetValues.cancelButtonIndex = actSheetValues.numberOfButtons-1;
    [actSheetValues showInView:self.view];
}
-(IBAction)goBack:(id)sender{
    
    NSMutableArray *arrTemp =[[NSMutableArray alloc] init];
    for (NSDictionary *dictTemp in self.arrPriceRange) {
        
        [arrTemp addObject:[dictTemp valueForKey:@"pricerangeid"]];
    }
    
    if ([arrTemp count]<1) {
      /*  [Utility showAlertWithTitle:@"Please select price range" withMessage:nil];
        return;*/
    }
    else
    {
        NSString *strIds =[arrTemp componentsJoinedByString:@","];
        
        [[NSUserDefaults standardUserDefaults] setValue:strIds forKey:@"priceRangesIds"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"PriceRanges"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    
    [self.navigationController popViewControllerAnimated:true];
}
-(void)updateCountLabel{
    
    [lblLeftRanges setText:[NSString stringWithFormat:@"%u price ranges left",4-self.arrPriceRange.count]];
}
-(void)getPriceRangesFromServer{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    
    NSString *post = [NSString stringWithFormat: @"token=%@",STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/pricerange_list"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                self.arrDropDownVal =[[NSMutableArray alloc]init];
                for (NSDictionary *dictData in [dict valueForKey:@"data"]){
                    [self.arrDropDownVal addObject:dictData];
                }
              
                
                NSArray *arrSelectedValues =[[[NSUserDefaults standardUserDefaults] valueForKey:@"priceRangesIds"] componentsSeparatedByString:@","];
                
                if (arrSelectedValues.count>0) {
                    
                    self.arrPriceRange =[[NSMutableArray alloc] init];
                    for (NSDictionary *dictData in [dict valueForKey:@"data"]){
                        
                        if ([arrSelectedValues containsObject:[dictData valueForKey:@"pricerangeid"] ]) {
                            self.dictFirstObject=[[dict valueForKey:@"data"] firstObject];

                            [self.arrPriceRange addObject:dictData];
                        }
                        
                        
                    }
                    
                }
                else{
                    if ([[dict valueForKey:@"data"] count]>0) {
                        
                        self.dictFirstObject =[[dict valueForKey:@"data"] firstObject];
                        
                        self.arrPriceRange=[[NSMutableArray alloc] initWithObjects:self.dictFirstObject, nil];
                        
                        
                    }
                }
                
               [self updateCountLabel];
                
                [tblView reloadData];
                
            }
            else{
                
                [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                return;
            }
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];

}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    [self.view endEditing:true];
    
      if (actionSheet==actSheetValues) {
        
        if (buttonIndex!=actionSheet.cancelButtonIndex) {
            
            [self.arrPriceRange replaceObjectAtIndex:selectedRow withObject:[self.arrDropDownVal objectAtIndex:buttonIndex]];
            
            //[tblView reloadSections:[NSIndexSet indexSetWithIndex:selectedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tblView reloadData];
        }
    }
}
@end
