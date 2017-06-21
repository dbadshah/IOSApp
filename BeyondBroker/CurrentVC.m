//
//  CurrentVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 14/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "CurrentVC.h"
#import "CurrentTabCell.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "WebServiceCall.h"
@interface CurrentVC ()

@end

@implementation CurrentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // [self getDataFromServer:nil];
    
    tblView.tableFooterView=[UIView new];
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
