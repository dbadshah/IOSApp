//
//  PastVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 14/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "PastVC.h"
#import "CurrentTabCell.h"
@interface PastVC ()

@end

@implementation PastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    tblView.tableFooterView=[UIView new];
    [tblView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return self.arrData.count;
    return 2;
    
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

@end
