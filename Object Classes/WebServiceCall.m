//
//  WebServiceCall.m
//  CarHealth
//
//  Created by Linath on 07/11/14.
//  Copyright (c) 2014 Linath. All rights reserved.
//

#import "WebServiceCall.h"

#import "NSData+Base64.h"

@implementation WebServiceCall
void(^getServerResponseForUrlCallback)(BOOL success, NSData *response, NSError *error);

-(void)sendRequestWithUrl:(NSString *)url withData:(NSData *)data withMehtod:(NSString *)method withLoadingAlert:(NSString *)loadingText withCompletionBlock:(ASCompletionBlock)responseData{
    
    
   getServerResponseForUrlCallback = responseData;
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120];
    
    [request setHTTPBody:data];
    [request setHTTPMethod:method];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];

    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

   
    //if you use rest api with post then this content type used.
   // [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    

    //if you use image then
    //
    /*NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];*/
    
    
    
    //if you use json string send
    //[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    


    
//    if (![NSURLConnection canHandleRequest:request]) {
//        NSLog(@"Can't handle request...");
//        return;
//    }

    
    /*if you are using authentication other wise use willSendRequestForAuthenticationChallenge delegate method
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"admin", @"1234"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@",[authData base64EncodedString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];*/
    
    
    NSURLConnection *urlConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [urlConnection start];
    
    if(urlConnection){
        
        mutableData = [[NSMutableData alloc]init];
    }
    
    objUtility=[Utility getInstance];
    
    if (loadingText.length>0) {

        [objUtility showLoadingWithText:loadingText];
    }
    
    
    
}
/*- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"Kdh64rJw"
                                                             password:@"aF2taB5U"
                                                          persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}*/

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"receive data");
    [mutableData appendData:data];

}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
        NSLog(@"finish loading");
        getServerResponseForUrlCallback(TRUE,mutableData,nil);
        [objUtility hideProgress];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
        getServerResponseForUrlCallback(FALSE,mutableData,error);
        [objUtility hideProgress];
    
}

+(WebServiceCall *)getInstance{
    
    WebServiceCall *objWebServiceCall =[[WebServiceCall alloc] init];
    return objWebServiceCall;
}
-(Connection *)sendRequestWithUrl:(NSString *)url withData:(NSData *)data withMethod:(NSString *)method{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [request setHTTPBody:data];
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSError *error;
   
    NSData *returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    Connection *objConnection=[[Connection alloc] init];
    objConnection.error=error;
    objConnection.response=returnData;
    if (error==nil)
        objConnection.success=TRUE;
    else
        objConnection.success=FALSE;
    
    
    return objConnection;
    
}

@end
