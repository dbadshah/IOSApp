//
//  RoomDetailVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 16/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"
@interface RoomDetailVC : UIViewController <UITextViewDelegate>{
    
    IBOutlet UILabel  *lblCharCount;
    IBOutlet SAMTextView *txtView;
}
@property(strong,nonatomic) NSString *room_id;

@end
