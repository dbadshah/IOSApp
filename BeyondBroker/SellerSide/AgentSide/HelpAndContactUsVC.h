//
//  HelpAndContactUsVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpAndContactUsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSString *strTitle;

@end
