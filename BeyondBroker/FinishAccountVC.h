//
//  FinishAccountVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 16/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishAccountVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIButton *btnSubmit;
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *arrCompleteFlag;
@end
