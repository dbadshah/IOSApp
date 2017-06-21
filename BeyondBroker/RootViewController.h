//
//  RootViewController.h
//  BashayerZon
//
//  Created by Sarthak Patel on 07/02/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKJPagerViewController.h"

@interface RootViewController : NKJPagerViewController<UIActionSheetDelegate>
@property(strong,nonatomic)NSMutableArray *arrMenu;
@property(strong,nonatomic)UIActionSheet *actSheetOption;
-(void)switchToIndex:(NSInteger)index;
@end
