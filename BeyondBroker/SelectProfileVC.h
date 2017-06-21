//
//  SelectProfileVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 08/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectProfileVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *footerView;
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *arrCompleteFlag;
@property(strong,nonatomic)NSDictionary *DictData;
@end
