//
//  TimeLine.h
//  BeyondBroker
//
//  Created by Webcore Solution on 15/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLine : NSObject
@property(strong,nonatomic) NSString *ConfigID;
@property(strong,nonatomic) NSString *ConfigType;
@property(strong,nonatomic) NSString *ConfigLabel;
@property(strong,nonatomic) NSString *ConfigValue;
@property(strong,nonatomic) NSString *IsActive;
@end
