//
//  DisplayAgentProfileVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 16/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZillowList.h"
#import "AgentList.h"
@interface DisplayAgentProfileVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
  CGSize cellSize;
  float screenWidth;
  IBOutlet UITableView *tblview;
  IBOutlet UIView *tblHeaderView;
  IBOutlet UIImageView *imgUser;
  IBOutlet UILabel *lblAgentName;
    
    
    
}
@property(strong,nonatomic) AgentList *objAgentList;
@property(strong,nonatomic) NSMutableArray *arrZillow;
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *arrSelectedId;
@property(strong,nonatomic)IBOutlet UICollectionView *objCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UIView *RateView;
@property (strong, nonatomic) IBOutlet UILabel *lblReview;
@property (strong, nonatomic) IBOutlet UILabel *lblRecentSales;

@end



