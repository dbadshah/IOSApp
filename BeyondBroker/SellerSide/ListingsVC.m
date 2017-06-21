//
//  ListingsVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 18/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ListingsVC.h"
#import "ListingCell.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "SelectAddressVC.h"
#import "PropertyList.h"
#import "AnalysesVC.h"
#import "SellingReasonVC.h"
#import "PhotoHomeVC.h"
#import "SelectAgentVC.h"
#import "ReviewSubmissionVC.h"
#import "DataManager.h"
#import "NSData+Base64.h"
@interface ListingsVC ()

@end

@implementation ListingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self RemoveProperty];

}
-(void)RemoveProperty{
    
    [UserDefault removeObjectForKey:HOME_ID];
    [UserDefault removeObjectForKey:CITY];
    [UserDefault removeObjectForKey:STATE];
    [UserDefault removeObjectForKey:ZIPCODE];
    
    [UserDefault removeObjectForKey:USECODE];
    [UserDefault removeObjectForKey:HOME_BED];
    [UserDefault removeObjectForKey:HOME_BATH];
    [UserDefault removeObjectForKey:SQFT];
    [UserDefault removeObjectForKey:YEAR_BUILT];
    [UserDefault removeObjectForKey:ADDRESS];
    
    [UserDefault removeObjectForKey:TIMELINE];
    [UserDefault removeObjectForKey:TIMELINE_ID];
    [UserDefault removeObjectForKey:REASON_FOR_SELLING];
    [UserDefault removeObjectForKey:HOME_COMMENT];
    [UserDefault removeObjectForKey:KIND_OF_AGENT];
    [UserDefault removeObjectForKey:@"selectAgentid"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    tblView.tableFooterView=[UIView new];
    [self registerNibForCustomCell];
    [self GetlistingData];

    [self.navigationController.navigationBar setHidden:true];
}
-(void)registerNibForCustomCell{
    
    UINib *nibListingCell=[UINib nibWithNibName:@"ListingCell" bundle:nil];
    [tblView registerNib:nibListingCell forCellReuseIdentifier:@"ListingCell"];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrData count];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PropertyList *objPropertyList = [self.arrData objectAtIndex:indexPath.row];
    
    ListingCell *ObjListingCell =  [tableView dequeueReusableCellWithIdentifier:@"ListingCell"];
    NSString *address=[NSString stringWithFormat:@"%@",objPropertyList.address];
    ObjListingCell.lblTitle.text=address;
  
    NSString *Description=[NSString stringWithFormat:@"%@ %@ %@",objPropertyList.city,objPropertyList.state,objPropertyList.zipcode];
    ObjListingCell.lblDesc.text=Description;
    
    if ([objPropertyList.step_id isEqualToString:@"5"]) {
        
        ObjListingCell.lblListed.text=@"Complete";
        ObjListingCell.lblListed.textColor=[Utility getColor:GREEN_COLOR];
        
    }else{
        
        ObjListingCell.lblListed.text=@"Request not submitted";
        ObjListingCell.lblListed.textColor=[Utility getColor:ORANGE_COLOR];

    }

    return ObjListingCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblView deselectRowAtIndexPath:indexPath animated:true];
    PropertyList *objPropertyList = [self.arrData objectAtIndex:indexPath.row];
    NSString *Property_id=[NSString stringWithFormat:@"%@",objPropertyList.property_id];
    [UserDefault setObject:Property_id forKey:PROPERTY_ID];
    
    if ([objPropertyList.step_id isEqualToString:@"5"]) {
        
        AnalysesVC *objAnalysVC =[[AnalysesVC alloc] initWithNibName:@"AnalysesVC" bundle:nil];
        [self.navigationController pushViewController:objAnalysVC animated:true];
    
    
    }else{
        
        [self getNotSubmitData];
    
    }
   
}
-(IBAction)btnNewAnalysisClick:(id)sender {

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_EDIT];
    SelectAddressVC *objSelectAddressVC =[[SelectAddressVC alloc] initWithNibName:@"SelectAddressVC" bundle:nil];
    [self.navigationController pushViewController:objSelectAddressVC animated:true];
}
-(void)GetlistingData{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:@"No Internet!"  withMessage:@"You are not connected to internet, check your internet connection!"];
        return;
    }
    
    NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"];
    NSString *post = [NSString stringWithFormat: @"userid=%@&token=%@",user_id,@"1920573288"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_propertylist"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            self.arrData=[[NSMutableArray alloc]init];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
              
                for (NSDictionary *dictData in [dict valueForKey:@"data"]) {
                    
                    PropertyList *objPropertyList = [[PropertyList alloc] init];
                    objPropertyList.address =  CHECK_NULL_STRING([dictData valueForKey:@"address"]);
                    objPropertyList.city = CHECK_NULL_STRING([dictData valueForKey:@"city"]);
                    objPropertyList.home_id = CHECK_NULL_STRING([dictData valueForKey:@"home_id"]);
                    objPropertyList.property_id = CHECK_NULL_STRING([dictData valueForKey:@"property_id"]);
                    objPropertyList.state = CHECK_NULL_STRING([dictData valueForKey:@"state"]);
                    objPropertyList.status = CHECK_NULL_STRING([dictData valueForKey:@"status"]);
                    
                    NSString *stepid=[NSString stringWithFormat:@"%@",[dictData valueForKey:@"step_id"]];
                    objPropertyList.step_id = stepid;
                    
                    objPropertyList.userid = CHECK_NULL_STRING([dictData valueForKey:@"userid"]);
                    objPropertyList.zipcode = CHECK_NULL_STRING([dictData valueForKey:@"zipcode"]);
                   
                    [self.arrData addObject:objPropertyList];
                }
          
                [tblView reloadData];
                
            }else{
                
                //[Utility showAlertWithTitle:CHECK_NULL_STRING([dict valueForKey:@"errKey"]) withMessage:CHECK_NULL_STRING([dict valueForKey:@"message"])];
                return;
            }
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
    
}
-(void)getNotSubmitData{
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
      [Utility showAlertWithTitle:@"No Internet!"  withMessage:@"You are not connected to internet, check your internet connection!"];
      return;
    }
    
    NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"];
    NSString *Property_id=[[NSUserDefaults standardUserDefaults] valueForKey:PROPERTY_ID];
    
    NSString *post = [NSString stringWithFormat: @"userid=%@&token=%@&property_id=%@",user_id,@"1920573288",Property_id];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/update_seller_submission"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                NSString *agent_selecation=[NSString stringWithFormat:@"%@",[dict valueForKey:@"agent_selecation"]];
                [[NSUserDefaults standardUserDefaults] setValue:agent_selecation forKey:@"selectAgentid"];
                
                NSString *home_id=[NSString stringWithFormat:@"%@",[dict valueForKey:@"home_id"]];
                [UserDefault setObject:CHECK_NULL_STRING(home_id) forKey:HOME_ID];
                
                NSString *city=[NSString stringWithFormat:@"%@",[dict valueForKey:@"city"]];
                [UserDefault setObject:CHECK_NULL_STRING(city) forKey:CITY];
                
                NSString *state=[NSString stringWithFormat:@"%@",[dict valueForKey:@"state"]];
                [UserDefault setObject:CHECK_NULL_STRING(state) forKey:STATE];
                
                NSString *Zipcode=[NSString stringWithFormat:@"%@",[dict valueForKey:@"zipcode"]];
                [UserDefault setObject:CHECK_NULL_STRING(Zipcode) forKey:ZIPCODE];
                
                NSString *Usecode=[NSString stringWithFormat:@"%@",[dict valueForKey:@"home_type"]];
                [UserDefault setObject:CHECK_NULL_STRING(Usecode) forKey:USECODE];
                
                NSString *Homebed=[NSString stringWithFormat:@"%@",[dict valueForKey:@"bedrooms"]];
                [UserDefault setObject:CHECK_NULL_STRING(Homebed) forKey:HOME_BED];
    
                NSString *Homebath=[NSString stringWithFormat:@"%@",[dict valueForKey:@"bathrooms"]];
                [UserDefault setObject:CHECK_NULL_STRING(Homebath) forKey:HOME_BATH];
                
                NSString *sqft=[NSString stringWithFormat:@"%@",[dict valueForKey:@"SqFt1stFloor"]];
                [UserDefault setObject:CHECK_NULL_STRING(sqft) forKey:SQFT];

                NSString *yearbuilt=[NSString stringWithFormat:@"%@",[dict valueForKey:@"year_built"]];
                [UserDefault setObject:CHECK_NULL_STRING(yearbuilt) forKey:YEAR_BUILT];
                
                NSString *address=[NSString stringWithFormat:@"%@",[dict valueForKey:@"address"]];
                [UserDefault setObject:CHECK_NULL_STRING(address) forKey:ADDRESS];
                
                NSString *TimeLine=[NSString stringWithFormat:@"%@",[dict valueForKey:@"timeframe"]];
                [UserDefault setObject:CHECK_NULL_STRING(TimeLine) forKey:TIMELINE];
                
//                NSString *TimeLine_id=@"";
//                [UserDefault setObject:TimeLine_id forKey:TIMELINE_ID];
                
                NSString *reason_for_selling=[NSString stringWithFormat:@"%@",[dict valueForKey:@"reason_selling"]];
                [UserDefault setObject:CHECK_NULL_STRING(reason_for_selling) forKey:REASON_FOR_SELLING];
                
                NSString *Home_comment=[NSString stringWithFormat:@"%@",[dict valueForKey:@"home_commet"]];
                [UserDefault setObject:CHECK_NULL_STRING(Home_comment) forKey:HOME_COMMENT];
                
                NSString *Kind_of_agent=[NSString stringWithFormat:@"%@",[dict valueForKey:@"kind_of_agent_looking_for"]];
                [UserDefault setObject:CHECK_NULL_STRING(Kind_of_agent) forKey:KIND_OF_AGENT];
               
                [DATA_MANAGER DeletePhotoDetail];
                [DATA_MANAGER DeleteRoomDetail];
                
                self.allRoomArray=[[NSMutableArray alloc]init];
                self.allRoomArray=[dict valueForKey:@"allroom"];
          
            if (self.allRoomArray.count==0) {
                    
                    for (int i = 0; i < 1; i++)
                    {
                        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
                        objRoomDetail.room_id=@"1001";
                        objRoomDetail.room_name=@"Kitchen";
                        objRoomDetail.room_type=@"Kitchen";
                        objRoomDetail.room_details=@"";
                        objRoomDetail.photos_limit=@"2";
                        [DATA_MANAGER insertRoom:objRoomDetail];
                        
                    }
                    
                    NSInteger bed=[Homebed integerValue];
                    for (int i = 0; i < bed; i++)
                    {
                        int count =  1 +  i;
                        int roomid = 2001 + i;
                        
                        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
                        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
                        objRoomDetail.room_name=[NSString stringWithFormat:@"Bedroom %d",count];
                        objRoomDetail.room_type=@"Bedroom";
                        objRoomDetail.room_details=@"";
                        objRoomDetail.photos_limit=@"1";
                        [DATA_MANAGER insertRoom:objRoomDetail];
                        
                    }
                    
                    NSInteger bath =[Homebath integerValue];
                    for (int i = 0; i < bath; i++)
                    {
                        int count =  1 +  i;
                        int roomid = 3001 + i;
                        
                        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
                        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
                        objRoomDetail.room_name=[NSString stringWithFormat:@"Bathroom %d",count];
                        objRoomDetail.room_type=@"Bathroom";
                        objRoomDetail.room_details=@"";
                        objRoomDetail.photos_limit=@"1";
                        [DATA_MANAGER insertRoom:objRoomDetail];
                        
                    }
                    
                    for (int i = 0; i < 1; i++)
                    {
                        int roomid = 4001 + i;
                        
                        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
                        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
                        objRoomDetail.room_name=[NSString stringWithFormat:@"Other"];
                        objRoomDetail.room_type=@"Other";
                        objRoomDetail.room_details=@"";
                        objRoomDetail.photos_limit=@"0";
                        [DATA_MANAGER insertRoom:objRoomDetail];
                        
                    }
                
                    
                    
            }else{
                
                int j=0;
                int s=0;
                
                
                for (int i = 0; i <self.allRoomArray.count; i++)
                {
                
                    NSString *RoomType=[NSString stringWithFormat:@"%@",[[self.allRoomArray valueForKey:@"RoomType"] objectAtIndex:i]];
                    NSString *room_details=[NSString stringWithFormat:@"%@",[[self.allRoomArray valueForKey:@"room_desc"] objectAtIndex:i]];
                    
                    if ([RoomType isEqualToString:@"Kitchen"]) {
                        
                        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
                        objRoomDetail.room_id=@"1001";
                        objRoomDetail.room_name=@"Kitchen";
                        objRoomDetail.room_type=@"Kitchen";
                        objRoomDetail.room_details=CHECK_NULL_STRING(room_details);
                        objRoomDetail.photos_limit=@"2";
                        [DATA_MANAGER insertRoom:objRoomDetail];
                        
                    NSArray *room_images=[[self.allRoomArray valueForKey:@"room_images"] objectAtIndex:i];
                    
                    for (int i = 0; i < room_images.count; i++)
                     {
                         NSString *base64=[NSString stringWithFormat:@"%@",[room_images objectAtIndex:i]];
//                         NSString *Image = [ImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                         NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:Image]];
//                         NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                         
                         PhotoDetail *ObjphotoDetail=[[PhotoDetail alloc]init];
                         ObjphotoDetail.room_id=@"1001";
                         ObjphotoDetail.room_image=base64;
                         [DATA_MANAGER insertphoto:ObjphotoDetail];
                        
                    }
                        
                    }else if ([RoomType isEqualToString:@"Bedroom"]){
                        
                        int count =  1 +  j;
                        int roomid = 2001 + j;
                       
                        j++;
                        
                        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
                        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
                        objRoomDetail.room_name=[NSString stringWithFormat:@"Bedroom %d",count];
                        objRoomDetail.room_type=@"Bedroom";
                        objRoomDetail.room_details=CHECK_NULL_STRING(room_details);
                        objRoomDetail.photos_limit=@"1";
                        [DATA_MANAGER insertRoom:objRoomDetail];
                        
                         NSArray *room_images=[[self.allRoomArray valueForKey:@"room_images"] objectAtIndex:i];
                        
                        for (int i = 0; i <room_images.count; i++)
                        {
                            NSString *base64=[NSString stringWithFormat:@"%@",[room_images objectAtIndex:i]];
                            PhotoDetail *ObjphotoDetail=[[PhotoDetail alloc]init];
                            ObjphotoDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
                            ObjphotoDetail.room_image=base64;
                            [DATA_MANAGER insertphoto:ObjphotoDetail];
                            
                        }
                        
                        
                    }else if ([RoomType isEqualToString:@"Bathroom"]){
                        
                        
                        int count =  1 +  s;
                        int roomid = 3001 + s;
                        s++;
                        
                        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
                        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
                        objRoomDetail.room_name=[NSString stringWithFormat:@"Bathroom %d",count];
                        objRoomDetail.room_type=@"Bathroom";
                        objRoomDetail.room_details=CHECK_NULL_STRING(room_details);
                        objRoomDetail.photos_limit=@"1";
                        [DATA_MANAGER insertRoom:objRoomDetail];
                        
                         NSArray *room_images=[[self.allRoomArray valueForKey:@"room_images"] objectAtIndex:i];
                        
                        for (int i = 0; i <room_images.count; i++)
                        {
                            NSString *base64=[NSString stringWithFormat:@"%@",[room_images objectAtIndex:i]];
                            
                            PhotoDetail *ObjphotoDetail=[[PhotoDetail alloc]init];
                            ObjphotoDetail.room_id=[NSString stringWithFormat:@"%d",roomid];;
                            ObjphotoDetail.room_image=base64;
                            [DATA_MANAGER insertphoto:ObjphotoDetail];
                            
                        }
                    
                   
                    }else if ([RoomType isEqualToString:@"Other"]){
                        
                        int roomid = 4001;
                        
                        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
                        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
                        objRoomDetail.room_name=[NSString stringWithFormat:@"Other"];
                        objRoomDetail.room_type=@"Other";
                        objRoomDetail.room_details=CHECK_NULL_STRING(room_details);;
                        objRoomDetail.photos_limit=@"0";
                        [DATA_MANAGER insertRoom:objRoomDetail];

                        NSArray *room_images=[[self.allRoomArray valueForKey:@"room_images"] objectAtIndex:i];
                        
                        for (int i = 0; i <room_images.count; i++)
                        {
                            NSString *base64=[NSString stringWithFormat:@"%@",[room_images objectAtIndex:i]];
                            
                            PhotoDetail *ObjphotoDetail=[[PhotoDetail alloc]init];
                            ObjphotoDetail.room_id=[NSString stringWithFormat:@"%d",roomid];;
                            ObjphotoDetail.room_image=base64;
                            [DATA_MANAGER insertphoto:ObjphotoDetail];
                            
                        }
                        
                    }
                }
                
            }
                
                NSString *step_id=[NSString stringWithFormat:@"%@",[dict valueForKey:@"step_id"]];
                [self StepToMoveController:step_id];
    
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_EDIT];
            
            }else{
                
                //[Utility showAlertWithTitle:CHECK_NULL_STRING([dict valueForKey:@"errKey"]) withMessage:CHECK_NULL_STRING([dict valueForKey:@"message"])];
                
                return;
            }
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
}
-(void)StepToMoveController:(NSString *)step_id{
    
    if ([step_id isEqualToString:@"1"]) {
        
        SellingReasonVC *objSellingReasonVC =[[SellingReasonVC alloc] initWithNibName:@"SellingReasonVC" bundle:nil];
        [self.navigationController pushViewController:objSellingReasonVC animated:true];
        
    }else if ([step_id isEqualToString:@"2"]){
        
        PhotoHomeVC *objPhotoHomeVC =[[PhotoHomeVC alloc] initWithNibName:@"PhotoHomeVC" bundle:nil];
        [self.navigationController pushViewController:objPhotoHomeVC animated:true];
        
    }else if ([step_id isEqualToString:@"3"]){
        
        SelectAgentVC *objSelectAgentVC =[[SelectAgentVC alloc] initWithNibName:@"SelectAgentVC" bundle:nil];
        [self.navigationController pushViewController:objSelectAgentVC animated:true];
        
    }else{
        
        ReviewSubmissionVC *objReviewSubmissionVC =[[ReviewSubmissionVC alloc]
                                                    initWithNibName:@"ReviewSubmissionVC" bundle:nil];
        [self.navigationController pushViewController:objReviewSubmissionVC animated:true];
        
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, iPhone?7.0f:10.0f)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:TRUE];
}
@end
