//
//  IntroDetailVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 14/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"
@interface IntroDetailVC : UIViewController<UITextViewDelegate>
{
    IBOutlet UILabel *navTitle,*lblCharCount;
    IBOutlet SAMTextView *txtView;
}
@property(assign,nonatomic)NSUInteger optionSelected;

@end
