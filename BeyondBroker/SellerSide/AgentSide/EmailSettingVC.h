//
//  EmailSettingVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 22/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailSettingVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
    
    
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *arrDescrption;
@property(strong,nonatomic)NSMutableArray *arrCompleteFlag;

@end
