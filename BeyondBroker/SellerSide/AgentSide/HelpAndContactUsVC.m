//
//  HelpAndContactUsVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "HelpAndContactUsVC.h"
#import "ContactCell.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "ContactDetailVC.h"
@interface HelpAndContactUsVC ()

@end

@implementation HelpAndContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tblView.tableFooterView=[UIView new];
    _lblTitle.text=self.strTitle;

}
-(void)viewWillAppear:(BOOL)animated{
    
    tblView.rowHeight = UITableViewAutomaticDimension;
    tblView.estimatedRowHeight = 110;
    [tblView reloadData];

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35.0f;

}
- (IBAction)btnContactClick:(id)sender {

    ContactDetailVC *objContactDetailVC =[[ContactDetailVC alloc] initWithNibName:@"ContactDetailVC" bundle:nil];
    [self.navigationController pushViewController:objContactDetailVC animated:true];

}
- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
   UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tblView.frame.size.width, 50.0)];
   sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerLabel;
    headerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, sectionHeaderView.frame.size.width, 20.0)];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [sectionHeaderView addSubview:headerLabel];
    headerLabel.text=[NSString stringWithFormat:@"CATEGORY 1"];
    return sectionHeaderView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"ContactCell";
    
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell==nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    return cell;
}
@end
