//
//  SellingReasonVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 19/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "SellingReasonVC.h"
#import "RadioButton.h"
#import "AgentLookVC.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "TimeLine.h"
#import "MMPickerView.h"
#import "PhotoHomeVC.h"
@interface SellingReasonVC ()
@property (nonatomic, strong) NSArray *stringsArray;
@property (nonatomic, assign) id selectedObject;
@property (nonatomic, strong) NSString * selectedString;
@end

TimeLine *objTimeList;

@implementation SellingReasonVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    // Do any additional setup after loading the view from its nib.
    otherView.layer.cornerRadius=2.0f;
    otherView.layer.borderColor=[UIColor grayColor].CGColor;
    otherView.layer.borderWidth=1.0f;
    otherView.layer.masksToBounds=true;
    
    dropDownView.layer.cornerRadius=2.0f;
    dropDownView.layer.borderColor=[UIColor grayColor].CGColor;
    dropDownView.layer.borderWidth=1.0f;
    dropDownView.layer.masksToBounds=true;

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [dropDownView addGestureRecognizer:singleFingerTap];
    
    
    
    [self GetlistingData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [UserDefault setObject:@"1" forKey:KIND_OF_AGENT];

    
    NSString *Reasonfor=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:REASON_FOR_SELLING]];
    if (Reasonfor.length>0) {
        
        [UserDefault setObject:@"Our home is too small. We need  an  upgrade." forKey:REASON_FOR_SELLING];
        [UserDefault setObject:@"" forKey:HOME_COMMENT];
   
    }else{
        
        if ([Reasonfor isEqualToString:@"Our home is too small. We need  an  upgrade."]) {
            
            [self.radioButton setSelected:0];
            
        }else if ([Reasonfor isEqualToString:@"Job relocation"]){
            
            [self.radioButton setSelected:1];
        
        }else if ([Reasonfor isEqualToString:@"Personal relationships"]){
            
            [self.radioButton setSelected:2];
        
        }else if ([Reasonfor isEqualToString:@"Neighborthood changes"]){
            
            [self.radioButton setSelected:3];
        
        }else if ([Reasonfor isEqualToString:@"See family more/less often"]){
            
            [self.radioButton setSelected:4];
      
        }else{
            
            [self.radioButton setSelected:6];
            NSString *Comment=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_COMMENT]];
            txtOther.text=Comment;
        }
    }
}
-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [MMPickerView showPickerViewInView:self.view
                           withStrings:_stringsArray
                           withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                         MMtextColor: [UIColor blackColor],
                                         MMtoolbarColor: [UIColor whiteColor],
                                         MMbuttonColor: [UIColor blueColor],
                                         MMfont: [UIFont systemFontOfSize:18],
                                         MMvalueY: @3,
                                         MMselectedObject:_selectedString,
                                         MMtextAlignment:@1}
                            completion:^(NSString *selectedString) {
                            
                            lblDropDown.text = selectedString;
                            _selectedString = selectedString;
    
        for (int i = 0; i < [self.arrData count]; i++)
            {
                TimeLine *objTimeLine = [[TimeLine alloc] init];
                objTimeLine=[self.arrData objectAtIndex:i];
                
             if ([_selectedString isEqualToString:objTimeLine.ConfigValue]) {
                                        
                    objTimeList=[self.arrData objectAtIndex:i];
                    [UserDefault setObject:objTimeList.ConfigID forKey:TIMELINE_ID];
                    [UserDefault setObject:objTimeList.ConfigValue forKey:TIMELINE];
                
            }
         }
    }];
}
-(IBAction)btnBackCLick:(id)sender {
    
   [self.navigationController popViewControllerAnimated:YES];

}
-(IBAction)btnNextCLick:(id)sender {

    NSString *homecomment=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_COMMENT]];
    
    if ([homecomment isEqualToString:@"6"]) {
        
         [UserDefault setObject:txtOther.text forKey:REASON_FOR_SELLING];
    }
    
    [self SubmitSetup2];
}
-(void)SubmitSetup2{
    
    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:@"No Internet!"  withMessage:@"You are not connected to internet, check your internet connection!"];
        return;
    }
    
    NSString *UserId=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:@"loginUserId"]];
    NSString *home_id=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_ID]];
    
    NSString *timeline=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:TIMELINE]];
    NSString *timeline_id=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:TIMELINE_ID]];
    NSString *reason_for_selling=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:REASON_FOR_SELLING]];
    NSString *home_comment=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_COMMENT]];
   
    NSString *kind_of_agent_looking_for=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:KIND_OF_AGENT]];
    
    NSString *post = [NSString stringWithFormat:@"token=%@&step_id=2&user_id=%@&home_id=%@&timeline_id=%@&timeline=%@&reason_for_selling=%@&home_comment=%@&@kind_of_agent_looking_for=%@",@"1920573288",UserId,home_id,timeline_id,timeline,reason_for_selling,home_comment,kind_of_agent_looking_for];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_property_save"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                PhotoHomeVC *objPhotoHomeVC =[[PhotoHomeVC alloc] initWithNibName:@"PhotoHomeVC" bundle:nil];
                [self.navigationController pushViewController:objPhotoHomeVC animated:true];
                
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

-(IBAction)onRadioBtn:(RadioButton*)sender
{
    NSString *selectValue = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    NSString *selectstring = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
    
    [UserDefault setObject:selectstring forKey:REASON_FOR_SELLING];
    [UserDefault setObject:@"" forKey:HOME_COMMENT];

    if ([selectValue isEqualToString:@"6"]) {
        
        [UserDefault setObject:txtOther.text forKey:REASON_FOR_SELLING];
        [UserDefault setObject:@"6" forKey:HOME_COMMENT];
    }
}
-(void)GetlistingData{
    
    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:@"No Internet!"  withMessage:@"You are not connected to internet, check your internet connection!"];
        return;
    }
    
    NSString *post = [NSString stringWithFormat:@"token=%@",@"1920573288"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/timeline_list"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            self.arrData=[[NSMutableArray alloc]init];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                self.stringsArray=[[dict valueForKey:@"data"]valueForKey:@"ConfigValue"];
                
                 _selectedString = [_stringsArray objectAtIndex:0];
                  lblDropDown.text = [_stringsArray objectAtIndex:0];
                
                for (NSDictionary *dictData in [dict valueForKey:@"data"]) {
                    
                    TimeLine *objTimeLine = [[TimeLine alloc] init];
                    objTimeLine.ConfigID =  CHECK_NULL_STRING([dictData valueForKey:@"ConfigID"]);
                    objTimeLine.ConfigType = CHECK_NULL_STRING([dictData valueForKey:@"ConfigType"]);
                    objTimeLine.ConfigLabel = CHECK_NULL_STRING([dictData valueForKey:@"ConfigLabel"]);
                    objTimeLine.ConfigValue = CHECK_NULL_STRING([dictData valueForKey:@"ConfigValue"]);
                    objTimeLine.IsActive = CHECK_NULL_STRING([dictData valueForKey:@"IsActive"]);
                    
                    [self.arrData addObject:objTimeLine];
                }
                
                objTimeList=[self.arrData objectAtIndex:0];
                [UserDefault setObject:objTimeList.ConfigID forKey:TIMELINE_ID];
                [UserDefault setObject:objTimeList.ConfigValue forKey:TIMELINE];
                
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
