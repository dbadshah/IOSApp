//
//  CommisionVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 17/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommisionVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;


}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *arrCompleteFlag;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property(strong,nonatomic)NSMutableArray *arrSelectedId;
@end
