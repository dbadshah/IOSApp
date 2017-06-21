//
//  ServiceProvideVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ServiceProvideVC.h"
#import "HomeTypesCell.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "WebServiceCall.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"
#import "CreateProfileVC.h"
#import "StartUpVC.h"


@interface ServiceProvideVC ()

@end

@implementation ServiceProvideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    screenWidth=[[UIScreen mainScreen] bounds].size.width;
    
    cellSize = CGSizeMake((screenWidth/3)-20,70);
    [self.objCollectionView registerNib:[UINib nibWithNibName:@"HomeTypesCell" bundle:nil] forCellWithReuseIdentifier:@"HomeTypesCellId"];
    
    NSArray *arrSelectedHomeTypes =[[UserDefault valueForKey:@"serviceTypesIds"] componentsSeparatedByString:@","];
    
    self.arrSelectedId =[[NSMutableArray alloc] initWithArray:arrSelectedHomeTypes];
    
    [self performSelector:@selector(getServicesDetailsFromServer) withObject:nil afterDelay:0.5];
    
}

#pragma mark -Collection View delegate mentods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // return iPhone?CGSizeMake(85,120):CGSizeMake(120, 120);
    
    return cellSize;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrData.count;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /* HomeCell *cellTemp =(HomeCell *)cell;
     NSLog(@"%@",NSStringFromCGRect(cellTemp.frame));
     NSLog(@"%@",NSStringFromCGRect(cellTemp.lblCount.frame));*/
    
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HomeTypesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTypesCellId" forIndexPath:indexPath];
    
    NSDictionary *dict =[self.arrData objectAtIndex:indexPath.row];
    
    cell.lblTitle.text=CHECK_NULL_STRING([dict valueForKey:@"servicename"]);
    
    if ([self.arrSelectedId containsObject:[dict valueForKey:@"id"]]) {
     
        cell.containerView.layer.borderWidth=1;
        cell.containerView.layer.borderColor=[Utility getColor:ORANGE_COLOR].CGColor;
        cell.containerView.layer.cornerRadius=3.0f;
        [cell.containerView setBackgroundColor:[Utility getColor:ORANGE_COLOR]];
        cell.lblTitle.textColor=[UIColor whiteColor];
        
    }
    else{
        cell.containerView.layer.borderWidth=1;
        cell.containerView.layer.borderColor=[UIColor grayColor].CGColor;
        cell.containerView.layer.cornerRadius=3.0f;
        [cell.containerView setBackgroundColor:[UIColor whiteColor]];
        cell.lblTitle.textColor=[UIColor darkGrayColor];
    }

    
    return cell;
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict =[self.arrData objectAtIndex:indexPath.row];
    
    NSString *tempId =[dict valueForKey:@"id"];
    
    if ([self.arrSelectedId containsObject:tempId]) {
        [self.arrSelectedId removeObject:tempId];
    }
    else{
        [self.arrSelectedId addObject:tempId];
    }
    
  [self.objCollectionView reloadItemsAtIndexPaths:@[indexPath]];

}
-(IBAction)goBack:(id)sender{
    
    if (self.arrSelectedId.count<1) {
      /*  [Utility showAlertWithTitle:@"Please select home types" withMessage:nil
         ];
        return;*/
        [self.navigationController popViewControllerAnimated:true];
        
    }
    else
    {
        NSString *commaSepIds =self.arrSelectedId.count>0?[self.arrSelectedId componentsJoinedByString:@","]:nil;
        
        NSLog(@"%@",[self.arrSelectedId componentsJoinedByString:@","] );
        
        //[UserDefault setValue:commaSepIds forKey:@"serviceTypesIds"];
        //[UserDefault setBool:true forKey:@"ServiceProvide"];
        
        NSMutableArray *arrServiceTypeNames =[[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in self.arrData) {
            
            if ([self.arrSelectedId containsObject:[dict valueForKey:@"id"]]) {
                
                [arrServiceTypeNames addObject:[dict valueForKey:@"servicename"]];
            }
            
        }
        
        NSString *commaSeparatedNames =[arrServiceTypeNames componentsJoinedByString:@","];
        //[UserDefault setValue:commaSeparatedNames forKey:@"serviceTypesNames"];
        //[UserDefault synchronize];
    
        [self.view endEditing:true];
        if (![Utility isInternetConnected]) {
            
            [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
            return;
            
        }
        
        NSString *post = [NSString stringWithFormat: @"agentid=%@&token=%@&save_type=3&service=%@&service_name=%@",
            CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),
            STATIC_TOKEN,commaSepIds,commaSeparatedNames];
        
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
-(void)getServicesDetailsFromServer{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    
    NSString *post = [NSString stringWithFormat: @"token=%@",STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_service"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                self.arrData =[[NSMutableArray alloc]init];
                for (NSDictionary *dictData in [dict valueForKey:@"data"]) {
                    
                    [self.arrData addObject:dictData];
                }
                [self.objCollectionView reloadData];
                
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

@end
