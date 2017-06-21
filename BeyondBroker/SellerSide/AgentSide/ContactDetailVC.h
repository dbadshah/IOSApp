//
//  ContactDetailVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"
@interface ContactDetailVC : UIViewController<UITextViewDelegate>
{
    IBOutlet UILabel *navTitle;
    IBOutlet UILabel  *lblCharCount;
    IBOutlet SAMTextView *txtView;
}
@end
