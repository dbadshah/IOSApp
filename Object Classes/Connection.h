//
//  Connection.h
//  CarHealth
//
//  Created by Linath on 10/11/14.
//  Copyright (c) 2014 Linath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject

@property(nonatomic,assign)BOOL success;
@property(strong,nonatomic)NSData *response;
@property(strong,nonatomic) NSError *error;

@end
