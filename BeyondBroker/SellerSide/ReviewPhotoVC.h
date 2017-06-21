//
//  ReviewPhotoVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 09/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewPhotoVC : UIViewController{
    
    IBOutlet UITableView *tblview;
    
}

@property(strong,nonatomic) NSMutableArray *arrData;
@property(strong,nonatomic) NSMutableArray *arrImage;

@property(strong,nonatomic) NSMutableArray *jsonArray;
@property(strong,nonatomic) NSMutableArray *jsonData;

@property(strong,nonatomic) NSDictionary *PhotoDict;
@property(strong,nonatomic) NSDictionary *Dictdata;

@end
