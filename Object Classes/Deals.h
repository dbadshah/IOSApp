//
//  Deals.h
//  BashayerZon
//
//  Created by Sarthak Patel on 30/01/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deals : NSObject

@property(strong,nonatomic)NSString *dealId;
@property(strong,nonatomic)NSString *dealUniqueId;
@property(strong,nonatomic)NSString *dealTitle;
@property(strong,nonatomic)NSString *dealImage;
@property(strong,nonatomic)NSString *dealBrandId;
@property(strong,nonatomic)NSString *dealCatId;
@property(strong,nonatomic)NSString *dealSubCatId;
@property(strong,nonatomic)NSString *dealView;
@property(strong,nonatomic)NSString *dealLocation;
@property(strong,nonatomic)NSString *dealBrand;
@property(strong,nonatomic)NSString *dealMrpPrice;
@property(strong,nonatomic)NSString *dealSellPrice;
@property(strong,nonatomic)NSString *dealDiscount;

-(Deals *)initWithDict:(NSDictionary *)dict;
@end
