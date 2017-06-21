//
//  SelectAgentVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 13/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAgentVC : UIViewController{
    
    IBOutlet UILabel *lblSelectCount;
    IBOutlet UITableView *tblview;
    IBOutlet UIButton *btnReview;
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic) NSMutableArray *arrZillow;
@property(strong,nonatomic)NSMutableArray *arrSelectedId;



@end
