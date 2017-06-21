//
//  SearchCityVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddCityDelegate <NSObject>
-(void)selectWithCity:(NSString *)city;
@end;

@interface SearchCityVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UISearchBar *objSearchBar;

}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)id <AddCityDelegate>delegate;
@end
