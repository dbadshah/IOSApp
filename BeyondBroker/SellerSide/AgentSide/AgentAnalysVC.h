//
//  AgentAnalysVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 22/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentAnalysVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property (strong, nonatomic) IBOutlet UIButton *BtnCurrent;
@property (strong, nonatomic) IBOutlet UIButton *btnListing;

@end
