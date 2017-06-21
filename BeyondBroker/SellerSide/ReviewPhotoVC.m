//
//  ReviewPhotoVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 09/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ReviewPhotoVC.h"
#import "Utility.h"
#import "DataManager.h"
#import "ReviewimageCell.h"
#import "CollectionView.h"
#import "DataManager.h"
#import "SelectAgentVC.h"
#import "WebServiceCall.h"
@interface ReviewPhotoVC ()


@end

@implementation ReviewPhotoVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
      self.arrImage = [[NSMutableArray alloc] init];
    
      self.arrData = [DATA_MANAGER getRoomList];
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
    
      NSLog(@"%lu",(unsigned long)self.arrImage.count);
    
    // Register the table cell
    [tblview registerClass:[ReviewimageCell class] forCellReuseIdentifier:@"ReviewimageCell"];
    
  
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrImage count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewimageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewimageCell"];
    NSMutableArray *cellData = [self.arrImage objectAtIndex:indexPath.row];
    NSMutableArray *articleData = cellData;
    [cell setCollectionData:articleData];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblview deselectRowAtIndexPath:indexPath animated:true];
    
    // This code is commented out in order to allow users to click on the collection view cells.
    //    if (!self.detailViewController) {
    //        self.detailViewController = [[ORGDetailViewController alloc] initWithNibName:@"ORGDetailViewController" bundle:nil];
    //    }
    //    NSDate *object = _objects[indexPath.row];
    //    self.detailViewController.detailItem = object;
    //    [self.navigationController pushViewController:self.detailViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

#pragma mark - NSNotification to select table cell
- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
//    NSDictionary *cellData = [notification object];
//    if (cellData)
//    {
//        if (!self.detailViewController)
//        {
//            self.detailViewController = [[ORGDetailViewController alloc] initWithNibName:@"ORGDetailViewController" bundle:nil];
//        }
//        self.detailViewController.detailItem = cellData;
//        [self.navigationController pushViewController:self.detailViewController animated:YES];
//    }
}
-(IBAction)btnChooseAgentClick:(id)sender{
    

    self.jsonArray = [[NSMutableArray alloc] init];
    self.jsonData=[[NSMutableArray alloc]init];
    
    self.jsonData = [DATA_MANAGER getRoomList];
    NSLog(@"%d",self.jsonData.count);
    
    
    for (int i = 1; i <= self.jsonData.count; i++)
    {
        RoomDetail * ObjRoomDetail=[self.jsonData objectAtIndex:i - 1];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        
        NSMutableArray *Array = [[NSMutableArray alloc] init];
        Array = [DATA_MANAGER getPhotoList:ObjRoomDetail.room_id];
        
        for (int j = 0; j < Array.count; j++)
        {
            PhotoDetail *ObjPhotoDetail = [Array objectAtIndex:j];
            [array1 addObject:ObjPhotoDetail.room_image];
        }
      
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:ObjRoomDetail.room_id,@"RoomId",ObjRoomDetail.room_type,@"RoomType",ObjRoomDetail.room_name,@"RoomName",ObjRoomDetail.room_details,@"RoomDetails",array1,@"roomPhotoList", nil];
        
        [self.jsonArray addObject:dict];
        
        if (self.jsonData.count == i) {
            
            [self SubmitSetup3];
        
        }
    }
}
-(void)SubmitSetup3{
    
    
    NSDictionary *param=[[NSDictionary alloc] initWithObjectsAndKeys:self.jsonArray,@"roomDetailses", nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *finalJsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:@"No Internet!"  withMessage:@"You are not connected to internet, check your internet connection!"];
        return;
    }
    
    NSString *UserId=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:@"loginUserId"]];
    NSString *home_id=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_ID]];
    
    NSString *post = [NSString stringWithFormat:@"token=%@&step_id=3&user_id=%@&home_id=%@&room_photo_list=%@",@"1920573288",UserId,home_id,CHECK_NULL_STRING(finalJsonString)];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_property_save"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        //Seller_Webservice/seller_property_save
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                SelectAgentVC *objSelectAgentVC =[[SelectAgentVC alloc] initWithNibName:@"SelectAgentVC" bundle:nil];
                [self.navigationController pushViewController:objSelectAgentVC animated:true];
                
            }else{
                
                [Utility showAlertWithTitle:nil withMessage:CHECK_NULL_STRING([dict valueForKey:@"message"])];
                return;
            }
            
        }else{
            
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
    
}
@end
