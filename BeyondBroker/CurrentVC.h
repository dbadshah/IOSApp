//
//  CurrentVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 14/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
}
@property(strong,nonatomic)NSMutableArray *arrData;

@end
