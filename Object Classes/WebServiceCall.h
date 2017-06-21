//
//  WebServiceCall.h
//  CarHealth
//
//  Created by Linath on 07/11/14.
//  Copyright (c) 2014 Linath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utility.h"
#import "Connection.h"
@interface WebServiceCall : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData *mutableData;
    Utility *objUtility;

}
typedef void (^ASCompletionBlock)(BOOL success, NSData *response, NSError *error);

//-(void)sendRequestWithUrl:(NSString *)url withData:(NSData *)data withMehtod:(NSString *)method withCompletionBlock:(ASCompletionBlock)responseData;
-(void)sendRequestWithUrl:(NSString *)url withData:(NSData *)data withMehtod:(NSString *)method withLoadingAlert:(NSString *)loadingText withCompletionBlock:(ASCompletionBlock)responseData;


-(Connection *)sendRequestWithUrl:(NSString *)url withData:(NSData *)data withMethod:(NSString *)method;

+(WebServiceCall *)getInstance;
@end