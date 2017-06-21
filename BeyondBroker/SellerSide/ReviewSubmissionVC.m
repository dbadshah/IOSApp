//
//  ReviewSubmissionVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 14/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ReviewSubmissionVC.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "AgentList.h"
#import "AgentImageCell.h"
#import "UIImageView+WebCache.h"
#import "CollectionSubmissionView.h"
#import "ReviewsubmitCell.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "ThankSubmissionVC.h"
@interface ReviewSubmissionVC ()

@end

@implementation ReviewSubmissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.arrSelectedData=[[NSMutableArray alloc]init];
    
    screenWidth=[[UIScreen mainScreen] bounds].size.width;
    cellSize = CGSizeMake(120,120);
    [tblview setTableHeaderView:tblHeaderView];
    
    [self registerNibForCustomCell];
    
    self.arrImage = [[NSMutableArray alloc] init];
    self.arrData = [DATA_MANAGER getRoomList];
    [self GetlistingData];
    
    for (int i = 0; i < self.arrData.count; i++)
    {
        RoomDetail * ObjRoomDetail=[self.arrData objectAtIndex:i];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        
        NSMutableArray *Array = [[NSMutableArray alloc] init];
        Array = [DATA_MANAGER getPhotoList:ObjRoomDetail.room_id];
        
        for (int j = 0; j < Array.count; j++)
        {
            PhotoDetail *ObjPhotoDetail = [Array objectAtIndex:j];
            
            NSDictionary *dictimage = [[NSDictionary alloc] initWithObjectsAndKeys:ObjPhotoDetail.Id,@"photo_id",
                                       ObjPhotoDetail.room_image,@"room_image", nil];
            
            [array1 addObject:dictimage];
            
        }
        
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:ObjRoomDetail.room_id,@"room_id",ObjRoomDetail.room_name,@"room_name",ObjRoomDetail.room_details,@"room_detail",array1,@"photos", nil];
        
        [self.arrImage addObject:dict];
        
    }
    
    NSString *Address=[NSString stringWithFormat:@"Location: %@",[UserDefault valueForKey:ADDRESS]];
    lblAddress.text=CHECK_NULL_STRING(Address);
    
    NSString *YearBuilt=[NSString stringWithFormat:@"Year built: %@",[UserDefault valueForKey:YEAR_BUILT]];
    lblYearBuilt.text=CHECK_NULL_STRING(YearBuilt);
    
    NSString *usecode=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:USECODE]];
    lblUseCode.text=CHECK_NULL_STRING(usecode);
    
    NSString *HomeBed=[NSString stringWithFormat:@"Beds: %@",[UserDefault valueForKey:HOME_BED]];
    lblBed.text=CHECK_NULL_STRING(HomeBed);
    
    NSString *HomeBath=[NSString stringWithFormat:@"Baths: %@",[UserDefault valueForKey:HOME_BATH]];
    lblBath.text=CHECK_NULL_STRING(HomeBath);

    NSString *Sqft=[NSString stringWithFormat:@"sqft: %@",[UserDefault valueForKey:SQFT]];
    lblSqft.text=CHECK_NULL_STRING(Sqft);

    [tblview registerClass:[ReviewsubmitCell class] forCellReuseIdentifier:@"ReviewsubmitCell"];

}
-(void)createArray{
    
    NSArray *arrSelectedAgent =[[UserDefault valueForKey:@"selectAgentid"] componentsSeparatedByString:@","];
    self.arrSelectedId =[[NSMutableArray alloc] initWithArray:arrSelectedAgent];
    
    for (int i = 0; i < self.arrAgentList.count; i++)
    {
        AgentList *objAgentList =[self.arrAgentList objectAtIndex:i];
     
        if ([self.arrSelectedId containsObject:objAgentList.agentid]) {
        
            [self.arrSelectedData addObject:objAgentList];
        
        }
    
    }
 
  [self performSelector:@selector(ReloadData) withObject:nil afterDelay:0.5];
    
}
-(void)ReloadData{
    
    [CollectionView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrImage count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewsubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsubmitCell"];
    NSMutableArray *cellData = [self.arrImage objectAtIndex:indexPath.row];
    NSMutableArray *articleData = cellData;
    [cell setCollectionData:articleData];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblview deselectRowAtIndexPath:indexPath animated:true];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}
-(void)registerNibForCustomCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"AgentImageCell" bundle:nil];
    [CollectionView registerNib:cellNib forCellWithReuseIdentifier:@"AgentImageCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.arrSelectedData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AgentImageCell";
    
    AgentList *objAgentList =[self.arrSelectedData objectAtIndex:indexPath.row];
    AgentImageCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.lblName.text=[NSString stringWithFormat:@"%@ %@",objAgentList.firstname,objAgentList.lastname];
   
    NSString *strImg=objAgentList.profileimg;
    NSString *Image = [strImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.UserImage sd_setImageWithURL:[NSURL URLWithString:Image]
                  placeholderImage:[UIImage imageNamed:Image]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         cell.UserImage.image=image;
     }];
    
    cell.layer.cornerRadius=5;
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
    
    NSString *post = [NSString stringWithFormat: @"token=%@",@"1920573288"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/agent_selection_list"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            
            self.arrAgentList=[[NSMutableArray alloc]init];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                for (NSDictionary *dictData in [dict valueForKey:@"data"]) {
                    
                    AgentList *ObjAgent = [[AgentList alloc] init];
                    ObjAgent.agentid =  CHECK_NULL_STRING([dictData valueForKey:@"agentid"]);
                    ObjAgent.firstname = CHECK_NULL_STRING([dictData valueForKey:@"firstname"]);
                    ObjAgent.lastname = CHECK_NULL_STRING([dictData valueForKey:@"lastname"]);
                    ObjAgent.profileimg = CHECK_NULL_STRING([dictData valueForKey:@"profileimg"]);
                    ObjAgent.firmname = CHECK_NULL_STRING([dictData valueForKey:@"firmname"]);
                    ObjAgent.experience = CHECK_NULL_STRING([dictData valueForKey:@"experience"]);
                    ObjAgent.quickintro = CHECK_NULL_STRING([dictData valueForKey:@"quickintro"]);
                    ObjAgent.aboutme = CHECK_NULL_STRING([dictData valueForKey:@"aboutme"]);
                    ObjAgent.videolink = CHECK_NULL_STRING([dictData valueForKey:@"videolink"]);
                    ObjAgent.serviceprovided = CHECK_NULL_STRING([dictData valueForKey:@"serviceprovided"]);
                    ObjAgent.agent_zipper_profile = CHECK_NULL_STRING([dictData valueForKey:@"agent_zipper_profile"]);
                    
                    [self.arrAgentList addObject:ObjAgent];
                }
                
             [self performSelector:@selector(createArray) withObject:nil afterDelay:0.5];
                
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

-(IBAction)btnSubmitClick:(id)sender {
    
    self.arrImage = [[NSMutableArray alloc] init];
    self.arrData=[[NSMutableArray alloc]init];
    
    self.arrData = [DATA_MANAGER getRoomList];
    
    
    for (int i = 1; i <= self.arrData.count; i++)
    {
        RoomDetail * ObjRoomDetail=[self.arrData objectAtIndex:i - 1];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        
        NSMutableArray *Array = [[NSMutableArray alloc] init];
        Array = [DATA_MANAGER getPhotoList:ObjRoomDetail.room_id];
        
        for (int j = 0; j < Array.count; j++)
        {
            PhotoDetail *ObjPhotoDetail = [Array objectAtIndex:j];
            [array1 addObject:ObjPhotoDetail.room_image];
        }
        
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:ObjRoomDetail.room_id,@"RoomId",ObjRoomDetail.room_type,@"RoomType",ObjRoomDetail.room_name,@"RoomName",ObjRoomDetail.room_details,@"RoomDetails",array1,@"roomPhotoList", nil];
        
        [self.arrImage addObject:dict];
        
        if (self.arrData.count == i) {
            
            [self SubmitData];
            
        }
    }


}

-(void)SubmitData{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    
    NSString *UserId=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:@"loginUserId"]];
    
    NSString *home_id=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_ID]];
    NSString *City=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:CITY]];
    NSString *State=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:STATE]];
    NSString *Zip_code=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:ZIPCODE]];
   
    NSString *home_type=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:USECODE]];
    NSString *bedrooms=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_BED]];
    NSString *bathrooms=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_BATH]];
    NSString *finishedSqFt=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:SQFT]];
    NSString *yearBuilt=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:YEAR_BUILT]];
    NSString *search_home_address=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:ADDRESS]];

    
    NSString *timeline=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:TIMELINE]];
    NSString *timeline_id=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:TIMELINE_ID]];
    NSString *reason_for_selling=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:REASON_FOR_SELLING]];
    NSString *home_comment=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_COMMENT]];
    NSString *kind_of_agent_looking_for=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:KIND_OF_AGENT]];

   

    NSArray *arrSelectedAgent =[[UserDefault valueForKey:@"selectAgentid"] componentsSeparatedByString:@","];
    
    NSError *errors;
    NSData *jsonDatas = [NSJSONSerialization dataWithJSONObject:arrSelectedAgent
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&errors];
    NSString *agent_selection =[[NSString alloc] initWithData:jsonDatas encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictParam =[[NSDictionary alloc] initWithObjectsAndKeys:
                              CHECK_NULL_STRING(search_home_address),@"address",
                              CHECK_NULL_STRING(bedrooms),@"bedrooms",
                              CHECK_NULL_STRING(bathrooms),@"bathrooms",
                              CHECK_NULL_STRING(finishedSqFt),@"finishedSqFt",
                              CHECK_NULL_STRING(yearBuilt),@"year_built",
                              CHECK_NULL_STRING(home_type),@"home_type",
                              CHECK_NULL_STRING(UserId),@"user_id",
                              CHECK_NULL_STRING(agent_selection),@"agent_selection",
                             
                              CHECK_NULL_STRING(home_id),@"home_id",
                              CHECK_NULL_STRING(City),@"city",
                              CHECK_NULL_STRING(State),@"state",
                              CHECK_NULL_STRING(Zip_code),@"zipcode",
                              
                              CHECK_NULL_STRING(timeline),@"timeline",
                              CHECK_NULL_STRING(timeline_id),@"timeline_id",
                              CHECK_NULL_STRING(reason_for_selling),@"reason_for_selling",
                              CHECK_NULL_STRING(home_comment),@"home_comment",
                              CHECK_NULL_STRING(kind_of_agent_looking_for),@"kind_of_agent_looking_for",
                              self.arrImage,@"roomDetailses",
                              
                              nil];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictParam options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *finalJsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *post = [NSString stringWithFormat: @"home_details=%@&token=%@",CHECK_NULL_STRING(finalJsonString),STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_property_insert"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                ThankSubmissionVC *objThankSubmissionVC=[[ThankSubmissionVC alloc] initWithNibName:@"ThankSubmissionVC" bundle:nil];
                [self.navigationController pushViewController:objThankSubmissionVC animated:true];
            
            }else{
                
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
-(IBAction)btnTimeLineEditClick:(id)sender {
    
    
}
-(IBAction)btnSelectAgentEditClick:(id)sender {


}
-(IBAction)btnPhotoTakenEditClick:(id)sender {
    
    
}
@end
