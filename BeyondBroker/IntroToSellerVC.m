//
//  IntroToSellerVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "IntroToSellerVC.h"
#import "SelectProfileCell.h"
#import "IntroDetailVC.h"
#import "Utility.h"

@interface IntroToSellerVC ()

@end

@implementation IntroToSellerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
}
-(void)viewWillAppear:(BOOL)animated{
    self.arrData =[[NSMutableArray alloc] initWithObjects:@"Quick Intro",@"Experience and education",@"Fun fact about you", nil];
    
    self.arrCompleteFlag =[[NSMutableArray alloc] initWithObjects:
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isQuickIntro"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isExpAndEdu"]],
                           [NSNumber numberWithBool:[UserDefault boolForKey:@"isFunAndFact"]],
                           nil];
    
    tblView.tableFooterView=[UIView new];
    [tblView reloadData];
}

-(IBAction)goBack:(id)sender{
    
    if (![UserDefault boolForKey:@"isQuickIntro"]) {
     
        [Utility showAlertWithTitle:@"Please enter quick intro." withMessage:nil];
        return;
    }
    else if (![UserDefault boolForKey:@"isExpAndEdu"])
    {
        [Utility showAlertWithTitle:@"Please enter experiece and education details." withMessage:nil];
        return;
    }
    else if (![UserDefault boolForKey:@"isFunAndFact"])
    {
        [Utility showAlertWithTitle:@"Please enter fun and fact about you." withMessage:nil];
        
        return;
    }
    
    //[UserDefault setBool:true forKey:@"IntroToSeller"];
    //[UserDefault synchronize];
    
    
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
    IntroDetailVC *objIntroDetailVC =[[IntroDetailVC alloc] initWithNibName:@"IntroDetailVC" bundle:nil];
    objIntroDetailVC.optionSelected=indexPath.row;
    [self.navigationController pushViewController:objIntroDetailVC animated:true];
    
}
@end
