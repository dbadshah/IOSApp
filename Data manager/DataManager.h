//
//  DataManager.h
//  BiddingApp
//
//  Created by Sarthak Patel on 04/01/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "RoomDetail.h"
#import "PhotoDetail.h"
#define DATA_MANAGER [DataManager getInstance]

@interface DataManager : NSObject
@property(strong,nonatomic) NSString *dbPath;

+(DataManager *)getInstance;
- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

#pragma mark - Contacts Methods

//-(void)updateCart:(NSString *)ProductQty withUniqueId:(NSString *)productId;
//-(NSMutableArray *)getCartProduct:(NSString *)ProductID;
//-(void)DeleteCart:(NSString *)productId;
//-(void)DeleteNotification;

-(void)DeleteRoomDetail;
-(void)DeletePhotoDetail;
-(NSString *)getAllRoomLimit;

-(NSString *)getRoomDescription:(NSString *)room_id;
-(NSMutableArray *)getRoomList;
-(NSMutableArray *)getPhotoList;
-(void)UpdateRoomDescription:(NSString *)room_id roomdescription:(NSString *)room_des;
-(void)insertRoom:(RoomDetail *)objRoomDetail;
-(void)insertphoto:(PhotoDetail *)objPhotoDetail;
-(NSMutableArray *)getimageList;

-(NSMutableArray *)getPhotoList:(NSString *)Room_id;


@end
