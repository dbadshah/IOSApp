//
//  PriceRangeVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 08/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceRangeVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewHeader,*viewFooter;
    IBOutlet UILabel *lblLeftRanges;
    UIActionSheet *actSheetValues;
    NSInteger selectedRow;
}
@property(strong,nonatomic)NSMutableArray *arrPriceRange;
@property(strong,nonatomic)NSMutableArray *arrDropDownVal;
@property(strong,nonatomic)NSDictionary *dictFirstObject;
@end
