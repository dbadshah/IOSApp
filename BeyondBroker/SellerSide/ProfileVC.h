//
//  ProfileVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 18/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *footerView;
    IBOutlet UILabel *lblUserName;
}
@property(strong,nonatomic)NSMutableArray *arrData;

@end
