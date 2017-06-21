//
//  FinishAccountVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 16/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "FinishAccountVC.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "SelectProfileCell.h"
#import "LeadsAndListingsVC.h"
#import "PaymentMethodVC.h"
#import "WebServiceCall.h"
#import "RootViewController.h"
@interface FinishAccountVC ()

@end

@implementation FinishAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.arrData =[[NSMutableArray alloc] initWithObjects:@"Leads and Listings",@"Payment Methods", nil];
    
    self.arrCompleteFlag =[[NSMutableArray alloc] initWithObjects:
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isLeadsAndListings"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isPaymentMethod"]],
                           nil];
    
    tblView.tableFooterView=[UIView new];
    
    
    
    BOOL isAllValueFilled=true;
    
    if (![UserDefault boolForKey:@"isLeadsAndListings"]) {
        
        isAllValueFilled=false;
    }
    else if (![UserDefault boolForKey:@"isPaymentMethod"])
    {
        isAllValueFilled=false;
        
    }
    
    
    if (isAllValueFilled) {
        
        [btnSubmit setHidden:false];
    }
    else{
        [btnSubmit setHidden:true];
    }
    
    
    
    [tblView reloadData];
    
}

-(IBAction)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:true];
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
            LeadsAndListingsVC *objLeadsAndListings =[[LeadsAndListingsVC alloc] initWithNibName:@"LeadsAndListingsVC" bundle:nil];
            [self.navigationController pushViewController:objLeadsAndListings animated:true];
        }
        break;
        case 1:
        {
            PaymentMethodVC *objPaymentMethodVC =[[PaymentMethodVC alloc] initWithNibName:@"PaymentMethodVC" bundle:nil];
            [self.navigationController pushViewController:objPaymentMethodVC animated:true];
        }
        break;
        default:
            break;
    }
}
-(IBAction)submitButtonClick:(id)sender{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    
    
   // pmsubmit_paymentagentidtokensubmit_payment = {"lead":"1","leadAmount":"40.0","listing":"1","listingAmount":"50.0","payment""cardNumber":"655","expDate":"04 / 2017","securityCode":"655"}}Agent_Webservice/agent_analyse_dashboardtoken
    
    
    
    
    NSString *lead =[UserDefault valueForKey:@"selectedLeads"];
    NSString *leadAmount =[UserDefault valueForKey:@"amountPerLead"];
    
    NSString *listing =[UserDefault valueForKey:@"selectedListings"];
    NSString *listingAmount =[UserDefault valueForKey:@"amountPerListing"];
    
    NSString *payment =[UserDefault valueForKey:@""];
    
    NSString *cardNumber =[UserDefault valueForKey:@"CreditCardNumber"];
    NSString *expDate =[UserDefault valueForKey:@"expireDate"];
    NSString *securityCode =[UserDefault valueForKey:@"securityCode"];


    
    NSDictionary *dictParam =[[NSDictionary alloc] initWithObjectsAndKeys:
                              CHECK_NULL_STRING(lead),@"lead",
                              CHECK_NULL_STRING(leadAmount),@"leadAmount",
                              CHECK_NULL_STRING(listing),@"listing",
                              CHECK_NULL_STRING(listingAmount),@"listingAmount",
                              CHECK_NULL_STRING(payment),@"payment",
                              CHECK_NULL_STRING(cardNumber),@"cardNumber",
                              CHECK_NULL_STRING(expDate),@"expDate",
                              CHECK_NULL_STRING(securityCode),@"securityCode",
                              nil];
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictParam
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    
    NSString *finalJsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    
    NSString *post = [NSString stringWithFormat: @"submit_payment=%@&agentid=%@&token=%@",CHECK_NULL_STRING(finalJsonString),[UserDefault valueForKey:@"loginUserId"],STATIC_TOKEN];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_payment"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                [UserDefault setValue:@"3" forKey:@"isAgentProfile"];
                [UserDefault synchronize];
                
                
                RootViewController *objRootVC =[[RootViewController alloc] init];
                [self.navigationController pushViewController:objRootVC animated:true];
                
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
