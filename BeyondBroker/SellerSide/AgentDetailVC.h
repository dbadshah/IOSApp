//
//  AgentDetailVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 19/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"
@interface AgentDetailVC : UIViewController<UITextViewDelegate>{
    
    IBOutlet SAMTextView *txtView;

}
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic)  NSString *Text;
@property (strong, nonatomic)  NSString *Title;
@end
