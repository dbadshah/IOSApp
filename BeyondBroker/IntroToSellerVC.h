//
//  IntroToSellerVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroToSellerVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *arrCompleteFlag;

@end
