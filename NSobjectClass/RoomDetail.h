//
//  RoomDetail.h
//  BeyondBroker
//
//  Created by Webcore Solution on 31/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoDetail.h"

@interface RoomDetail : NSObject
@property(strong,nonatomic) NSString *Id;
@property(strong,nonatomic) NSString *room_id;
@property(strong,nonatomic) NSString *room_name;
@property(strong,nonatomic) NSString *room_type;
@property(strong,nonatomic) NSString *room_details;
@property(strong,nonatomic) NSString *photos_limit;
@property(nonatomic) NSInteger TakenPhotos;



@end
