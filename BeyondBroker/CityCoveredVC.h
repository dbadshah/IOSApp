//
//  CityCoveredVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 09/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCityVC.h"
@interface CityCoveredVC : UIViewController<UITableViewDelegate,UITableViewDataSource,AddCityDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewHeader,*viewFooter;
    IBOutlet UILabel *lblLeftRanges;
}
@property(strong,nonatomic)NSMutableArray *arrCities;

@end
