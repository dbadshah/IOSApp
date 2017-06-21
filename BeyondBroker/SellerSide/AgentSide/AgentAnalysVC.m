//
//  AgentAnalysVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 22/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "AgentAnalysVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "WebServiceCall.h"
#import "CurrentTabCell.h"

@interface AgentAnalysVC ()

@end

@implementation AgentAnalysVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.navigationController.navigationBar setHidden:true];
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    
    self.BtnCurrent.titleLabel.font=[UIFont fontWithName:Helvetica_Neue size:16.0f];
    self.btnListing.titleLabel.font=[UIFont fontWithName:Helvetica_Neue size:16.0f];

    [self btnHeaderClick:_BtnCurrent];
    
}
- (IBAction)btnHeaderClick:(id)sender {
    
    UIButton *instanceButton = (UIButton *)sender;
    NSInteger index =instanceButton.tag;
 
    
    if (index==1) {
        
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.BtnCurrent.frame.size.height - 1.50f, self.BtnCurrent.frame.size.width, 1.5)];
    bottomBorder.backgroundColor = [Utility getColor:ORANGE_COLOR];
    [self.BtnCurrent setTitleColor:[Utility getColor:ORANGE_COLOR] forState:UIControlStateNormal];
    [self.BtnCurrent addSubview:bottomBorder];
        
        
    UIView *bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.btnListing.frame.size.height - 1.50f, self.btnListing.frame.size.width, 1.5)];
    bottomBorder1.backgroundColor = [UIColor whiteColor];
    [self.btnListing setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnListing addSubview:bottomBorder1];

        
     
    }else{
        
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.BtnCurrent.frame.size.height - 1.50f, self.BtnCurrent.frame.size.width, 1.5)];
    bottomBorder.backgroundColor = [UIColor whiteColor];
    [self.BtnCurrent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.BtnCurrent addSubview:bottomBorder];
        
  
    UIView *bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.btnListing.frame.size.height - 1.50f, self.btnListing.frame.size.width, 1.5)];
    bottomBorder1.backgroundColor = [Utility getColor:ORANGE_COLOR];
    [self.btnListing setTitleColor:[Utility getColor:ORANGE_COLOR] forState:UIControlStateNormal];
    [self.btnListing addSubview:bottomBorder1];

        
    }

   [tblView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return self.arrData.count;
    return 5;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"CurrentTabCell";
    
    CurrentTabCell *cell = (CurrentTabCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CurrentTabCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    return cell;
}
-(IBAction)getDataFromServer:(id)sender{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    NSString *post = [NSString stringWithFormat: @"center_lat=%@&center_lng=%@&radius=%@",@"23.027148",@"72.508516",@"5000"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[@"http://132.148.85.86:8080/" stringByAppendingPathComponent:@"FoodjugaadWsApp/getHotelsDetailByRadius"] withData:postData withMehtod:@"POST" withLoadingAlert:LOADING_TITLE withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            self.arrData =[[NSMutableArray alloc] init];
            
            for (NSDictionary *dictData in [dict valueForKeyPath:@"data.restList"]) {
                
                [self.arrData addObject:[[dictData valueForKey:@"hotelCoverPageUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            
            
            [tblView reloadData];
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
    
    
    
}

@end
