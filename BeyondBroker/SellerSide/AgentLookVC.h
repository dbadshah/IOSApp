//
//  AgentLookVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 19/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@interface AgentLookVC : UIViewController



@property (nonatomic, strong) IBOutlet RadioButton* radioButton;
-(IBAction)onRadioBtn:(id)sender;
@end
