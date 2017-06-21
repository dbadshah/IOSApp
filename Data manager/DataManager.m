//
//  DataManager.m
//  BiddingApp
//
//  Created by Sarthak Patel on 04/01/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "DataManager.h"
#import "Utility.h"
@implementation DataManager
@synthesize dbPath;

sqlite3 *database;

- (void) copyDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    self.dbPath = [self getDBPath];
    
    BOOL success = [fileManager fileExistsAtPath:self.dbPath];
    
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"beyondbroker.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:self.dbPath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    [self openDatabase];
}

/********* Database Path *********/
- (NSString *) getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"beyondbroker.sqlite"];
}

-(void)openDatabase{
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK){
        
        NSLog(@"open Database");
    }
    else{
        NSLog(@"failed to open database");
    }
}
+(DataManager *)getInstance{
    
    DataManager *objDataManager =[[DataManager alloc] init];
    return objDataManager;
}


-(void)insertRoom:(RoomDetail *)objRoomDetail{
    
     sqlite3_stmt *statement;
     NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO Room (room_id,room_name,room_type,room_details,photos_limit) VALUES (%ld,'%@','%@','%@',%ld);",
    
                                (long)[objRoomDetail.room_id integerValue],
                                 DB_CHECK_NULL_STRING(objRoomDetail.room_name),
                                 DB_CHECK_NULL_STRING(objRoomDetail.room_type),
                                 DB_CHECK_NULL_STRING(objRoomDetail.room_details),
                                 (long)[objRoomDetail.photos_limit integerValue]];
    
    
        NSString *finalQuery =insertQuery;
        const char *insert_stmt = [finalQuery UTF8String];
    
        if (sqlite3_prepare_v2(database, insert_stmt,
                               -1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"room insert");
            }
            else{
    
               NSLog(@"%@",statement);
           
            }
      }
}


-(void)insertphoto:(PhotoDetail *)objPhotoDetail{
    
    sqlite3_stmt *statement;
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO RoomPhotos (room_id,room_image) VALUES (%ld,'%@');",
                             
            (long)[objPhotoDetail.room_id integerValue],
            DB_CHECK_NULL_STRING(objPhotoDetail.room_image)];
    
    NSString *finalQuery =insertQuery;
    const char *insert_stmt = [finalQuery UTF8String];
    
    if (sqlite3_prepare_v2(database, insert_stmt,
                           -1, &statement, NULL)==SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"photo insert");
        }
        else{
            
            NSLog(@"%@",statement);
            
        }
    }
    
}

-(NSMutableArray *)getRoomList{

    sqlite3_stmt    *statement;
    NSMutableArray *arrTemp =[[NSMutableArray alloc] init];

    NSString *selectQuery=  [NSString stringWithFormat:@"SELECT * from Room"];
    const char *select_stmt = [selectQuery UTF8String];
    if (sqlite3_prepare_v2(database, select_stmt,
                           -1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {

            RoomDetail *ObjRoomDetail =[[RoomDetail alloc] init];

           
            ObjRoomDetail.room_id=[[NSString alloc]
                               initWithUTF8String:(const char *)
                               sqlite3_column_text(statement, 1)];

            ObjRoomDetail.room_name=[[NSString alloc]
                                  initWithUTF8String:(const char *)
                                  sqlite3_column_text(statement, 2)];
            
            ObjRoomDetail.room_type=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 3)];
            
            ObjRoomDetail.room_details=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 4)];

            ObjRoomDetail.photos_limit=[[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 5)];
            
            [arrTemp addObject:ObjRoomDetail];

        }
    }

    return arrTemp;
}
-(NSMutableArray *)getPhotoList{
    
    sqlite3_stmt    *statement;
    NSMutableArray *arrTemp =[[NSMutableArray alloc] init];
    
    NSString *selectQuery=  [NSString stringWithFormat:@"SELECT * from RoomPhotos"];
    const char *select_stmt = [selectQuery UTF8String];
    if (sqlite3_prepare_v2(database, select_stmt,-1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            PhotoDetail *ObjPhotoDetail =[[PhotoDetail alloc] init];
            
            
            ObjPhotoDetail.room_id=[[NSString alloc]
                                   initWithUTF8String:(const char *)
                                   sqlite3_column_text(statement, 1)];
            
            ObjPhotoDetail.room_image=[[NSString alloc]
                                     initWithUTF8String:(const char *)
                                     sqlite3_column_text(statement, 2)];
            
            [arrTemp addObject:ObjPhotoDetail];
            
        }
    }
    
    return arrTemp;
}
-(NSString *)getAllRoomLimit{
    
    sqlite3_stmt    *statement;
    NSString *arrTemp =[[NSString alloc] init];
    
    NSString *selectQuery=  [NSString stringWithFormat:@"SELECT sum(photos_limit) from Room"];
    const char *select_stmt = [selectQuery UTF8String];
    if (sqlite3_prepare_v2(database, select_stmt,-1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            arrTemp =[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            
        }
    }
    
    return arrTemp;
}
-(NSMutableArray *)getPhotoList:(NSString *)Room_id{
    
    sqlite3_stmt    *statement;
    NSMutableArray *arrTemp =[[NSMutableArray alloc] init];
    
    NSString *selectQuery=  [NSString stringWithFormat:@"select * from RoomPhotos where  RoomPhotos.room_id='%@'",Room_id];
    
    const char *select_stmt = [selectQuery UTF8String];
    if (sqlite3_prepare_v2(database, select_stmt,-1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            PhotoDetail *ObjPhotoDetail =[[PhotoDetail alloc] init];
            
            ObjPhotoDetail.Id=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 0)];
            
            ObjPhotoDetail.room_image=[[NSString alloc]
                                    initWithUTF8String:(const char *)
                                    sqlite3_column_text(statement, 1)];
            
            ObjPhotoDetail.room_id=[[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 2)];
            
            [arrTemp addObject:ObjPhotoDetail];
            
        }
    }
    
    return arrTemp;
}
-(NSString *)getRoomDescription:(NSString *)room_id{
    
    sqlite3_stmt    *statement;
    NSString *arrTemp =[[NSString alloc] init];
    
    NSString *selectQuery=  [NSString stringWithFormat:@"SELECT room_details from Room where room_id='%@'",room_id];
    const char *select_stmt = [selectQuery UTF8String];
    if (sqlite3_prepare_v2(database, select_stmt,-1, &statement, NULL)==SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            arrTemp =[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            
        }
    }
    
    return arrTemp;
}
-(void)UpdateRoomDescription:(NSString *)room_id roomdescription:(NSString *)room_des{
    
    sqlite3_stmt    *statement;
    NSString *DeleteQuery =[NSString stringWithFormat:@"UPDATE Room set room_details='%@' where room_id='%@'",room_des,room_id];
    const char *select_stmt = [DeleteQuery UTF8String];
    
    if (sqlite3_prepare_v2(database, select_stmt,
                           -1, &statement, NULL)==SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_DONE)
            
            NSLog(@"update with Success");
        
    }
    
}
-(void)DeleteRoomDetail{

    sqlite3_stmt    *statement;
    NSString *DeleteQuery =[NSString stringWithFormat:@"delete from Room"];
    const char *select_stmt = [DeleteQuery UTF8String];

    if (sqlite3_prepare_v2(database, select_stmt,
                           -1, &statement, NULL)==SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_DONE)

            NSLog(@"Delete with Success");

    }
}
-(void)DeletePhotoDetail{
    
    sqlite3_stmt    *statement;
    NSString *DeleteQuery =[NSString stringWithFormat:@"delete from RoomPhotos"];
    const char *select_stmt = [DeleteQuery UTF8String];
    
    if (sqlite3_prepare_v2(database, select_stmt,
                           -1, &statement, NULL)==SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_DONE)
            
            NSLog(@"Delete with Success");
        
    }
}
@end
