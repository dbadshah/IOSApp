//
//  SelectProfileVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 08/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "SelectProfileVC.h"
#import "SelectProfileCell.h"
#import "HomeSpecializationVC.h"
#import "PriceRangeVC.h"
#import "CityCoveredVC.h"
#import "ZilloProfileVC.h"
#import "PhotoVideoVC.h"
#import "IntroToSellerVC.h"
#import "ServiceProvideVC.h"
#import "BrokerageVC.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"
#import "CreateProfileVC.h"
#import "StartUpVC.h"
#import "AppDelegate.h"
#import "CommisionVC.h"
@interface SelectProfileVC ()

@end

@implementation SelectProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.arrData =[[NSMutableArray alloc] initWithObjects:@"Home Specialization",@"Commission",@"Cities Covered",@"Zillow Profile(optional)",@"Photo/Video",@"Introductions to Sellers",@"Services you Provide",@"Brokerage", nil];
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    NSString *post = [NSString stringWithFormat: @"agentid=%@&token=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_finish_detail"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            self.DictData=[[NSDictionary alloc]init];
            
    if([[dict valueForKey:@"status"] integerValue]==1){
                
       self.DictData=[dict valueForKey:@"data"];
        
     //agent_home_type
     NSString *agent_home_type=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_home_type"]];
     [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(agent_home_type) forKey:@"homeTypesIds"];
          
     //agent_commission
     NSString *agent_commission=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_commission"]];
     [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(agent_commission) forKey:@"Commissionid"];
    
    //agent_city_name
    NSString *agent_city_name=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_city_name"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(agent_city_name) forKey:@"selectedCities"];
          
    //agent_zipper_profile
    NSString *zipper_profile=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_zipper_profile"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(zipper_profile) forKey:@"strZilloProfile"];
          
   //agent_services
    NSString *agent_services=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_services"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(agent_services) forKey:@"serviceTypesIds"];
   
          
    //videolink
    NSString *videolink=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"videolink"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(videolink) forKey:@"videoProfileUrl"];

    //profileimg
    NSString *profileimg=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"profileimg"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(profileimg) forKey:@"profileimg"];
          
    //agent_branch_office_phone
    NSString *BrokeragePhone=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_branch_office_phone"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(BrokeragePhone) forKey:@"BrokeragePhone"];
     
    //agent_brokerage_firm
    NSString *BrokerageFirm=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_brokerage_firm"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(BrokerageFirm) forKey:@"BrokerageFirm"];
     
    //agent_branch_office_adrs
    NSString *BrokerageAddress=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_branch_office_adrs"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(BrokerageAddress) forKey:@"BrokerageAddress"];

    //agent_branch_office_city
    NSString *BrokerageLandmark=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_branch_office_city"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(BrokerageLandmark) forKey:@"BrokerageLandmark"];
          
    //agent_branch_office_state
    NSString *BrokerageState=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_branch_office_state"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(BrokerageState) forKey:@"BrokerageState"];
    
    //agent_branch_office_zipcode
    NSString *BrokeragePinCode=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"agent_branch_office_zipcode"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(BrokeragePinCode) forKey:@"BrokeragePinCode"];
          

   //quickintro
    NSString *quickintro=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"quickintro"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(quickintro) forKey:@"quickIntro"];
          
    //education
    NSString *expAndEdu=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"education"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(expAndEdu) forKey:@"expAndEdu"];
    
    //aboutme
    NSString *funAndFact=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"aboutme"]];
    [[NSUserDefaults standardUserDefaults] setValue:CHECK_NULL_STRING(funAndFact) forKey:@"funAndFact"];
    
          
        //Home
        NSString *home_specialization=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"home_specialization"]];
          
          if ([home_specialization isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"HomeSpecialization"];

            }else{
              
              [UserDefault setBool:true forKey:@"HomeSpecialization"];
          
           }
          
         //Commission
         NSString *commission_section=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"commission_section"]];
         
          if ([commission_section isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"Commission"];
              
          }else{
              
              [UserDefault setBool:true forKey:@"Commission"];
          }
          
         //City
          NSString *city_covered=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"city_covered"]];
          if ([city_covered isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"CitiesCovered"];
              
          }else{
              
              [UserDefault setBool:true forKey:@"CitiesCovered"];
          }
          
          //ZilloProfile
          NSString *zillow_profile=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"zillow_profile"]];
          if ([zillow_profile isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"ZilloProfile"];
              
          }else{
              
              [UserDefault setBool:true forKey:@"ZilloProfile"];
          }
          
          //Photo
          NSString *profile_seller=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"profile_seller"]];
          if ([profile_seller isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"PhotoVideo"];
              
          }else{
              
              [UserDefault setBool:true forKey:@"PhotoVideo"];
          }
          
          //Intro seller
          NSString *introduce_seller=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"introduce_seller"]];
          
          if ([introduce_seller isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"IntroToSeller"];
              
          }else{
              
              [UserDefault setBool:true forKey:@"IntroToSeller"];
          }
          
          //Service
          NSString *service_provide=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"service_provide"]];
          if ([service_provide isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"ServiceProvide"];
              
          }else{
              
              [UserDefault setBool:true forKey:@"ServiceProvide"];
          }
          
          //Brokerage
          NSString *brokerage=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"brokerage"]];
          if ([brokerage isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"Brokerage"];
              
          }else{
              
              [UserDefault setBool:true forKey:@"Brokerage"];
          
          }
         
          //education_section
          NSString *education_section=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"education_section"]];
          if ([education_section isEqualToString:@"0"]) {
              
              [UserDefault setBool:false forKey:@"isExpAndEdu"];
              
          }else{
              
              [UserDefault setBool:true forKey:@"isExpAndEdu"];
              
          }
        
        //aboutme_section
        NSString *aboutme_section=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"aboutme_section"]];
        if ([aboutme_section isEqualToString:@"0"]) {
            
            [UserDefault setBool:false forKey:@"isFunAndFact"];
            
        }else{
            
            [UserDefault setBool:true forKey:@"isFunAndFact"];
            
        }
       
        //quick_section
        NSString *quick_section=[NSString stringWithFormat:@"%@",[self.DictData valueForKey:@"quick_section"]];
        if ([quick_section isEqualToString:@"0"]) {
            
            [UserDefault setBool:false forKey:@"isQuickIntro"];
            
        }else{
            
            [UserDefault setBool:true forKey:@"isQuickIntro"];
            
        }
        
        self.arrCompleteFlag =[[NSMutableArray alloc] initWithObjects:
                               [NSNumber numberWithBool:[UserDefault boolForKey:@"HomeSpecialization"]],
                               [NSNumber numberWithBool:[UserDefault boolForKey:@"Commission"]],
                               [NSNumber numberWithBool:[UserDefault boolForKey:@"CitiesCovered"]],
                               [NSNumber numberWithBool:[UserDefault boolForKey:@"ZilloProfile"]],
                               [NSNumber numberWithBool:[UserDefault boolForKey:@"PhotoVideo"]],
                               [NSNumber numberWithBool:[UserDefault boolForKey:@"IntroToSeller"]],
                               [NSNumber numberWithBool:[UserDefault boolForKey:@"ServiceProvide"]],
                               [NSNumber numberWithBool:[UserDefault boolForKey:@"Brokerage"]],
                               nil];
        
        BOOL isAllValueFilled=true;
        
        if (![UserDefault boolForKey:@"HomeSpecialization"]) {
            
            isAllValueFilled=false;
        }
        else if (![UserDefault boolForKey:@"Commission"])
        {
            isAllValueFilled=false;
            
        }
        else if (![UserDefault boolForKey:@"CitiesCovered"])
        {
            isAllValueFilled=false;
        }
        else if (![UserDefault boolForKey:@"ZilloProfile"])
        {
            isAllValueFilled=false;
        }
        else if (![UserDefault boolForKey:@"PhotoVideo"])
        {
            isAllValueFilled=false;
        }
        else if (![UserDefault boolForKey:@"IntroToSeller"])
        {
            isAllValueFilled=false;
        }
        else if (![UserDefault boolForKey:@"ServiceProvide"])
        {
            isAllValueFilled=false;
        }
        
        else if (![UserDefault boolForKey:@"Brokerage"])
        {
            isAllValueFilled=false;
        }
        
        if (isAllValueFilled) {
            tblView.tableFooterView=footerView;
        }
        else{
            tblView.tableFooterView=[UIView new];
        }
        
        [tblView reloadData];
        
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrData.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SelectProfileCell";

    SelectProfileCell *cell = (SelectProfileCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectProfileCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.lblTitle.text=[self.arrData objectAtIndex:indexPath.row];
    
    if ([[self.arrCompleteFlag objectAtIndex:indexPath.row] boolValue]) {
        
        cell.lblTitle.textColor =[UIColor grayColor];
        [cell.imgViewCheck setImage:[UIImage imageNamed:@"checked.png"]];
    }
    else{
      
        cell.lblTitle.textColor =[Utility getColor:ORANGE_COLOR];
        [cell.imgViewCheck setImage:[UIImage imageNamed:@"unchecked.png"]];
    
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  60.0f;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tblView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:
        {
        
        HomeSpecializationVC *objHomeSpecVC =[[HomeSpecializationVC alloc] initWithNibName:@"HomeSpecializationVC" bundle:nil];
        [self.navigationController pushViewController:objHomeSpecVC animated:true];
            
            
        }
        break;
            
        case 1:
        {
            CommisionVC *objPriceRangeVC =[[CommisionVC alloc] initWithNibName:@"CommisionVC" bundle:nil];
            [self.navigationController pushViewController:objPriceRangeVC animated:true];
        }
            break;
        case 2:
        {
            CityCoveredVC *objCityCoveredVC =[[CityCoveredVC alloc] initWithNibName:@"CityCoveredVC" bundle:nil];
            [self.navigationController pushViewController:objCityCoveredVC animated:true];
        }
            
            break;
        case 3:
        {
            ZilloProfileVC *objZilloProfileVC =[[ZilloProfileVC alloc] initWithNibName:@"ZilloProfileVC" bundle:nil];
            [self.navigationController pushViewController:objZilloProfileVC animated:true];
        }
            break;
        case 4:
        {
            PhotoVideoVC *objPhotoVideo =[[PhotoVideoVC alloc] initWithNibName:@"PhotoVideoVC" bundle:nil];
            [self.navigationController pushViewController:objPhotoVideo animated:true];
        }
            break;
        case 5:
        {
            IntroToSellerVC *objIntroToSellerVC =[[IntroToSellerVC alloc] initWithNibName:@"IntroToSellerVC" bundle:nil];
            [self.navigationController pushViewController:objIntroToSellerVC animated:true];
        }
            break;
        case 6:
        {
            ServiceProvideVC *objServiceProvideVC =[[ServiceProvideVC alloc] initWithNibName:@"ServiceProvideVC" bundle:nil];
            [self.navigationController pushViewController:objServiceProvideVC animated:true];
        }
            break;
        case 7:
        {
            BrokerageVC *objBrokerageVC =[[BrokerageVC alloc] initWithNibName:@"BrokerageVC" bundle:nil];
            [self.navigationController pushViewController:objBrokerageVC animated:true];
        }
            break;

        default:
            break;
    }
}
-(IBAction)submitProfileData:(id)sender{
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    
    UIImage *profImage =[UIImage imageWithContentsOfFile:[DOCUMENTPATH stringByAppendingPathComponent:@"ProfileImage.png"]];
    
    NSData *imageData = UIImageJPEGRepresentation(profImage, 0.5);
    NSString *strImage= [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSString *videoUrl =[UserDefault valueForKey:@"videoProfileUrl"];
    
    NSString *BrokerageFirm =[UserDefault valueForKey:@"BrokerageFirm"];
    NSString *BrokerageAddress =[UserDefault valueForKey:@"BrokerageAddress"];
    NSString *BrokerageLandmark =[UserDefault valueForKey:@"BrokerageLandmark"];
    NSString *BrokeragePinCode =[UserDefault valueForKey:@"BrokeragePinCode"];
    NSString *BrokerageState =[UserDefault valueForKey:@"BrokerageState"];
    NSString *BrokeragePhone =[UserDefault valueForKey:@"BrokeragePhone"];

    NSString *serviceTypesIds =[UserDefault valueForKey:@"serviceTypesIds"];
    NSString *serviceTypesNames =[UserDefault valueForKey:@"serviceTypesNames"];
    
    
    
    NSString *quickIntro =[UserDefault valueForKey:@"quickIntro"];
    NSString *expAndEdu =[UserDefault valueForKey:@"expAndEdu"];
    NSString *funAndFact =[UserDefault valueForKey:@"funAndFact"];
    
    NSString *strZilloProfile =[UserDefault valueForKey:@"strZilloProfile"];
    NSString *selectedCities =[UserDefault valueForKey:@"selectedCities"];
    
    NSString *priceRangesIds =[UserDefault valueForKey:@"Commissionid"];
 
    
    NSString *homeTypesIds =[UserDefault valueForKey:@"homeTypesIds"];
    NSDictionary *dictBrokerage =[NSDictionary dictionaryWithObjectsAndKeys:
                    CHECK_NULL_STRING(BrokerageAddress),@"address",
                    CHECK_NULL_STRING(BrokerageFirm),@"brokerage_firm",
                    CHECK_NULL_STRING(BrokerageLandmark),@"landmark",
                    CHECK_NULL_STRING(BrokeragePhone),@"phone",
                    CHECK_NULL_STRING(BrokeragePinCode),@"pincode",
                    CHECK_NULL_STRING(BrokerageState),@"state",
                                  nil];

    NSDictionary *dictParam =[[NSDictionary alloc] initWithObjectsAndKeys:CHECK_NULL_STRING(strImage),@"agent_profile_image",
                              CHECK_NULL_STRING(videoUrl),@"video_url",
                              CHECK_NULL_STRING(serviceTypesIds),@"service",
                              CHECK_NULL_STRING(serviceTypesNames),@"service_name",
                              CHECK_NULL_STRING(quickIntro),@"quick_intro",
                              CHECK_NULL_STRING(expAndEdu),@"experience",
                              CHECK_NULL_STRING(funAndFact),@"fun_facts",
                              CHECK_NULL_STRING(priceRangesIds),@"agent_commission",
                              CHECK_NULL_STRING(strZilloProfile),@"zillow_profile_name",
                              CHECK_NULL_STRING(selectedCities),@"city_covered",
                              CHECK_NULL_STRING(homeTypesIds),@"property_type",
                              dictBrokerage,@"brokerage_firm",
                              
                              
                              nil];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictParam
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    
    NSString *finalJsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    /* {
     "agent_profile_image": "",
     "brokerage_firm": {
     "address": "hyy",
     "brokerage_firm": "yt",
     "landmark": "njh",
     "phone": "6333",
     "pincode": "663",
     "state": ""
     },
     "city_covered": "KIRKLAND,KIRKLAND,KIRKLAND,KIRKLAND",
     "experience": "Iiii",
     "fun_facts": "Juj",
     "price_range": "3",
     "property_type": "1,4",
     "quick_intro": "Iuu",
     "service": "4,7",
     "video_url": "iii",
     "zillow_profile_name": "juu"
     }
     Agent_Webservice/agent_profile*/
    
    
    NSString *post = [NSString stringWithFormat: @"submit_profile=%@&agentid=%@&token=%@",CHECK_NULL_STRING(finalJsonString),[UserDefault valueForKey:@"loginUserId"],STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_profile"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                CreateProfileVC *objCreateProfile =[[CreateProfileVC alloc] initWithNibName:@"CreateProfileVC" bundle:nil];
                [self.navigationController pushViewController:objCreateProfile animated:true];
                
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

-(IBAction)logout{
    
    [Utility removeAllUserDefaults];
    
    StartUpVC *objStartUpVC =[[StartUpVC alloc] initWithNibName:@"StartUpVC" bundle:nil];
    
    UINavigationController *objNavcontroller =[[UINavigationController alloc] initWithRootViewController:objStartUpVC];

    [APP_WINDOW setRootViewController:objNavcontroller];
    
    [APP_WINDOW makeKeyAndVisible];
    
    
}
@end
