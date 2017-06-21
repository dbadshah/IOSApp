//
//  ReviewSubmissionVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 14/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewSubmissionVC : UIViewController{
    
    CGSize cellSize;
    float screenWidth;
    IBOutlet UITableView *tblview;
    IBOutlet UICollectionView *CollectionView;
    IBOutlet UIView *tblHeaderView;
    
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *lblYearBuilt;
    IBOutlet UILabel *lblUseCode;
    
    IBOutlet UILabel *lblBed;
    IBOutlet UILabel *lblBath;
    IBOutlet UILabel *lblSqft;
    IBOutlet UILabel *lblReason;
    IBOutlet UILabel *lblTimeLine;
    
    
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic) NSMutableArray *arrSelectedData;
@property(strong,nonatomic) NSMutableArray *arrImage;
@property(strong,nonatomic) NSDictionary *PhotoDict;
@property(strong,nonatomic) NSDictionary *Dictdata;
@property(strong,nonatomic)NSMutableArray *arrSelectedId;
@property(strong,nonatomic)NSMutableArray *arrAgentList;

@end
