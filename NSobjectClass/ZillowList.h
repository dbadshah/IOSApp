//
//  ZillowList.h
//  BeyondBroker
//
//  Created by Webcore Solution on 14/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZillowList : NSObject
@property(strong,nonatomic) NSString *avgRating;
@property(strong,nonatomic) NSString *reviewCount;
@property(strong,nonatomic) NSString *recentSaleCount;
@property(strong,nonatomic) NSArray *review;


@end
