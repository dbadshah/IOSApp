//
//  ListingsVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 18/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingsVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *tblHeaderView;
    
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *allRoomArray;
@end
