//
//  AnalysesVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 15/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "AnalysesVC.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "WebServiceCall.h"
#import "AgentAnalysesCell.h"
#import "AnalysesList.h"
#import "UIImageView+WebCache.h"
@interface AnalysesVC ()

@end

@implementation AnalysesVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    screenWidth=[[UIScreen mainScreen] bounds].size.width;
    cellSize = CGSizeMake((screenWidth/3)-20,120);
    
    [self registerNibForCustomCell];
    [self GetlistingData];
    
}
-(void)registerNibForCustomCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"AgentAnalysesCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"AgentAnalysesCell"];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.arrData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AgentAnalysesCell";
    
    AnalysesList *objAnalysesList=[self.arrData objectAtIndex:indexPath.row];
    
    AgentAnalysesCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *strImg=[NSString stringWithFormat:@"%@",objAnalysesList.profileimg];
    NSString *Image = [strImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.imgAgent sd_setImageWithURL:[NSURL URLWithString:Image]
                      placeholderImage:[UIImage imageNamed:Image]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         cell.imgAgent.image=image;
     }];
    
    
    cell.imgAgent.layer.cornerRadius = cell.imgAgent.frame.size.width / 2;
    cell.imgAgent.clipsToBounds = YES;
    
    cell.lblName.text=[NSString stringWithFormat:@"%@",objAnalysesList.name];
    cell.lblStatus.text=[NSString stringWithFormat:@"%@",objAnalysesList.aceeptstatus_value];
    
    NSString *status=[NSString stringWithFormat:@"%@",objAnalysesList.aceeptstatus_value];
    
    if ([status isEqualToString:@"Not started"]) {
        
        cell.lblStatus.textColor=[Utility getColor:GRAY_COLOR];
    
    }else if ([status isEqualToString:@"In-progress"]){
        
        cell.lblStatus.textColor=[Utility getColor:YELLOW_COLOR];
    
    }else if ([status isEqualToString:@"Complete"]){
        
        cell.lblStatus.textColor=[Utility getColor:GREEN_COLOR];
    
    }
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return cellSize;
}

-(void)GetlistingData{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:@"No Internet!"  withMessage:@"You are not connected to internet, check your internet connection!"];
        return;
    }
    
    NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"];
    NSString *Property_id=[[NSUserDefaults standardUserDefaults] valueForKey:PROPERTY_ID];
    
    NSString *post = [NSString stringWithFormat: @"userid=%@&token=%@&property_id=%@",user_id,@"1920573288",Property_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_property_anaylyse"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            self.arrData=[[NSMutableArray alloc]init];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                for (NSDictionary *dictData in [dict valueForKey:@"data"]) {
                    
                    AnalysesList *objAnalysesList = [[AnalysesList alloc] init];
                    objAnalysesList.aceeptstatus =  CHECK_NULL_STRING([dictData valueForKey:@"aceeptstatus"]);
                    objAnalysesList.aceeptstatus_value = CHECK_NULL_STRING([dictData valueForKey:@"aceeptstatus_value"]);
                    objAnalysesList.agentid = CHECK_NULL_STRING([dictData valueForKey:@"agentid"]);
                    objAnalysesList.name = CHECK_NULL_STRING([dictData valueForKey:@"name"]);
                    objAnalysesList.profileimg = CHECK_NULL_STRING([dictData valueForKey:@"profileimg"]);
                    objAnalysesList.select_agent = CHECK_NULL_STRING([dictData valueForKey:@"select_agent"]);
                    
                    [self.arrData addObject:objAnalysesList];
                }
                
                [self.collectionView reloadData];
                
            }else{
                
                [Utility showAlertWithTitle:nil withMessage:CHECK_NULL_STRING([dict valueForKey:@"message"])];
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
