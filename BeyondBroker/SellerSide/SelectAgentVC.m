//
//  SelectAgentVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 13/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "SelectAgentVC.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "RateView.h"
#import "SelectAgentCell.h"
#import "AgentList.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "XMLReader.h"
#import "ZillowList.h"
#import "ReviewSubmissionVC.h"
#import "DisplayAgentProfileVC.h"
@interface SelectAgentVC ()

@end

@implementation SelectAgentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSArray *arrSelectedAgent =[[UserDefault valueForKey:@"selectAgentid"] componentsSeparatedByString:@","];
    self.arrSelectedId =[[NSMutableArray alloc] initWithArray:arrSelectedAgent];
    lblSelectCount.text=[NSString stringWithFormat:@"%lu/5",(unsigned long)self.arrSelectedId.count];

    [self registerNibForCustomCell];
    [self GetlistingData];

}
-(IBAction)btnReviewClick:(id)sender{
    
    if (self.arrSelectedId.count > 5) {
        
       [Utility showAlertWithTitle:nil withMessage:@""];
    
    }else{
        
        NSString *commaSepIds = self.arrSelectedId.count>0?[self.arrSelectedId componentsJoinedByString:@","]:nil;
        [[NSUserDefaults standardUserDefaults] setValue:commaSepIds forKey:@"selectAgentid"];
        [self SubmitSetup4];
    
    }
}
-(void)SubmitSetup4{
    
    NSArray *arrSelectedAgent =[[UserDefault valueForKey:@"selectAgentid"] componentsSeparatedByString:@","];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrSelectedAgent
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
    
    NSString *post = [NSString stringWithFormat:@"token=%@&step_id=4&user_id=%@&home_id=%@&selected_agent_id=%@",@"1920573288",UserId,home_id,finalJsonString];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_property_save"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
              
                ReviewSubmissionVC *objReviewSubmissionVC =[[ReviewSubmissionVC alloc] initWithNibName:@"ReviewSubmissionVC" bundle:nil];
                [self.navigationController pushViewController:objReviewSubmissionVC animated:true];
          
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
-(void)registerNibForCustomCell{
    
    UINib *nibListingCell=[UINib nibWithNibName:@"SelectAgentCell" bundle:nil];
    [tblview registerNib:nibListingCell forCellReuseIdentifier:@"SelectAgentCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AgentList *objAgentList =[self.arrData objectAtIndex:indexPath.row];
    
    ZillowList *objZillowList =[self.arrZillow objectAtIndex:indexPath.row];
    
    SelectAgentCell *Cell =  [tableView dequeueReusableCellWithIdentifier:@"SelectAgentCell"];
    
    RateView* rateVw = nil;
    rateVw = [RateView rateViewWithRating:0.0f];
    rateVw.frame = CGRectMake(0, Cell.rateView.frame.size.height/2 - 8, Cell.rateView.frame.size.width, Cell.rateView.frame.size.height);
    rateVw.starSize = 15;
    rateVw.tag = 88888;
    rateVw.rating = [objZillowList.avgRating floatValue];
    
    rateVw.starNormalColor = [UIColor whiteColor];
    rateVw.starFillColor = [Utility getColor:GREEN_COLOR];
    rateVw.starBorderColor = [Utility getColor:GREEN_COLOR];
    [Cell.rateView addSubview:rateVw];
   
    
    NSString *strImg=objAgentList.profileimg;
    NSString *Image = [strImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Cell.profileImage sd_setImageWithURL:[NSURL URLWithString:Image]
                 placeholderImage:[UIImage imageNamed:Image]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
         Cell.profileImage.image=image;
    
     }];
   
    Cell.profileImage.layer.cornerRadius = Cell.profileImage.frame.size.width / 2;
    Cell.profileImage.clipsToBounds = YES;
    
    Cell.btnSelect.layer.cornerRadius=3;
    
    if ([self.arrSelectedId containsObject:objAgentList.agentid]) {
        
        Cell.btnSelect.backgroundColor=[Utility getColor:GREEN_COLOR];
        Cell.btnSelect.titleLabel.textColor=[UIColor whiteColor];
       
        [[Cell.btnSelect layer] setBorderWidth:0.0f];
        [[Cell.btnSelect layer] setBorderColor:[UIColor clearColor].CGColor];
        
    }else{
        
        Cell.btnSelect.backgroundColor=[UIColor whiteColor];
        Cell.btnSelect.titleLabel.textColor=[UIColor grayColor];
        [[Cell.btnSelect layer] setBorderWidth:1.0f];
        [[Cell.btnSelect layer] setBorderColor:[UIColor grayColor].CGColor];
    
    }
   
      Cell.btnSelect.tag=indexPath.row;
      [Cell.btnSelect addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
    
      Cell.lblExprince.text=objAgentList.experience;
      NSString *name =[NSString stringWithFormat:@"%@%@ >",objAgentList.firstname,objAgentList.lastname];
    
      [Cell.btnAgentName setTitle:name forState:UIControlStateNormal];
      Cell.btnAgentName.tag=indexPath.row;
      [Cell.btnAgentName addTarget:self action:@selector(btnAgentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
      Cell.lblReviews.text=[NSString stringWithFormat:@"(%@ reviews)",objZillowList.reviewCount];
      Cell.lblRecentcount.text= [NSString stringWithFormat:@"%@",objZillowList.recentSaleCount];
    
      return Cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tblview deselectRowAtIndexPath:indexPath animated:true];

}
-(void)btnAgentClick:(UIButton *)btn{

    AgentList *objAgentList =[self.arrData objectAtIndex:btn.tag];
    DisplayAgentProfileVC *objAgentProfileVC =[[DisplayAgentProfileVC alloc] initWithNibName:@"DisplayAgentProfileVC" bundle:nil];
    objAgentProfileVC.objAgentList=objAgentList;
    [self.navigationController pushViewController:objAgentProfileVC animated:true];

}
-(void)btnSelect:(UIButton *)btn{
    
    AgentList *objAgentList =[self.arrData objectAtIndex:btn.tag];
    
    if ([self.arrSelectedId containsObject:objAgentList.agentid]) {
        
       [self.arrSelectedId removeObject:objAgentList.agentid];
    
    }else{
       
       [self.arrSelectedId addObject:objAgentList.agentid];
    }

    lblSelectCount.text=[NSString stringWithFormat:@"%lu/5",(unsigned long)self.arrSelectedId.count];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    [tblview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)GetZillowlistingData{
    
    self.arrZillow=[[NSMutableArray alloc]init];
    
   for (int i = 1; i <= [self.arrData count]; i++)
    {
        
        AgentList *ObjAgent = [self.arrData objectAtIndex:i - 1];
       
        NSString *zilowurl=[NSString stringWithFormat:@"http://www.zillow.com/webservice/ProReviews.htm?zws-id=X1-ZWz199vp77f763_6zfs6&screenname=%@",ObjAgent.agent_zipper_profile];
        
        NSString *Url = [zilowurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.view endEditing:true];
        [[WebServiceCall getInstance] sendRequestWithUrl:Url withData:nil withMehtod:@"GET" withLoadingAlert:@"" withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        NSString *theXML = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary *dictResponce = [XMLReader dictionaryForXMLString:theXML error:&error];
        
        if (success) {
            
         NSDictionary *dict=[[dictResponce valueForKey:@"ProReviews:proreviewresults"] valueForKey:@"response"];
        
         NSString *avgRating = [NSString stringWithFormat:@"%@",[[[[dict valueForKey:@"result"]
                        valueForKey:@"proInfo"]valueForKey:@"avgRating"] valueForKey:@"text"]];
            
         NSString *reviewCount =[NSString stringWithFormat:@"%@",[[[[dict valueForKey:@"result"] valueForKey:@"proInfo"]valueForKey:@"reviewCount"] valueForKey:@"text"]];
         
         NSString *recentSaleCount =[NSString stringWithFormat:@"%@",[[[[dict valueForKey:@"result"] valueForKey:@"proInfo"]valueForKey:@"recentSaleCount"] valueForKey:@"text"]];
         
        NSArray *Review =[[[dict valueForKey:@"result"] valueForKey:@"proReviews"]valueForKey:@"review"];
            NSLog(@"%@",Review);
            
            ZillowList *objZillowList =[[ZillowList alloc]init];
            objZillowList.avgRating=CHECK_NULL_STRING(avgRating);
            objZillowList.recentSaleCount=CHECK_NULL_STRING(recentSaleCount);
            objZillowList.reviewCount=CHECK_NULL_STRING(reviewCount);
            
            [self.arrZillow addObject:objZillowList];
            
            if (self.arrZillow.count == i) {
                
                [tblview reloadData];
            }
          
         }
     }];
   }
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
            
            
            self.arrData=[[NSMutableArray alloc]init];
            
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
                    ObjAgent.education = CHECK_NULL_STRING([dictData valueForKey:@"education"]);
                    ObjAgent.serviceprovided = CHECK_NULL_STRING([dictData valueForKey:@"serviceprovided"]);
                    ObjAgent.agent_zipper_profile = CHECK_NULL_STRING([dictData valueForKey:@"agent_zipper_profile"]);
                   
                    [self.arrData addObject:ObjAgent];
                }
                
                [self GetZillowlistingData];
                
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
