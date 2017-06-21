//
//  CollectionSubmissionView.m
//  BeyondBroker
//
//  Created by Webcore Solution on 14/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "CollectionSubmissionView.h"
#import <QuartzCore/QuartzCore.h>
#import "CollectionViewCell.h"
#import "NSData+Base64.h"
#import "Utility.h"
@interface CollectionSubmissionView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *collectionData;
@property (strong, nonatomic) NSMutableArray *ArrData;

@end

@implementation CollectionSubmissionView
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(110, 110);
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    // Register the colleciton cell
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
}

-(void)setCollectionData:(NSMutableArray *)collectionData {
    
    _collectionData = [collectionData valueForKey:@"photos"];
    self.ArrData=collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
   return self.collectionData.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *roomname=[NSString stringWithFormat:@"%@",[self.ArrData valueForKey:@"room_name"]];
    _lblRoomName.text=roomname;
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.collectionData.count) {
        
        NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
        NSString *base64String=[NSString stringWithFormat:@"%@",[cellData valueForKey:@"room_image"]];
        
        UIImage *image = [UIImage imageWithData:[NSData dataFromBase64String:base64String]];
        cell.Roomimage.image=image;
        
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
    
}



@end
