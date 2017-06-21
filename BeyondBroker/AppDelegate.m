//
//  AppDelegate.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 04/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "AppDelegate.h"
#import "StartUpVC.h"
#import "RootViewController.h"
#import "Utility.h"
#import "CreateProfileVC.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <Google/SignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DataManager.h"

//#warning Replace YOUR_API_KEY with your Google Places API key
static NSString *const kHNKDemoGooglePlacesAutocompleteApiKey = @"AIzaSyDx4eBbdwnPGRslKu404TWS1jgE1CaHQJA";

@import GoogleMaps;
@interface AppDelegate () <UIApplicationDelegate, GIDSignInDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [DATA_MANAGER copyDatabaseIfNeeded];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GIDSignIn sharedInstance].delegate = self;

    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey: kHNKDemoGooglePlacesAutocompleteApiKey];
    [GMSServices provideAPIKey:@"AIzaSyCB_Fsyiy2Fez5Orpt9UXO3TzXJ4XFGphw"];
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self prepareUserDefaults];
    [self registerForNotification];

    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
      
        StartUpVC *objStartUpVC =[[StartUpVC alloc] initWithNibName:@"StartUpVC" bundle:nil];
        self.navController =[[UINavigationController alloc] initWithRootViewController:objStartUpVC];
        [self.window setRootViewController:self.navController];

    }else{
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"isAgentProfile"]);
        
         if([[[NSUserDefaults standardUserDefaults] valueForKey:@"roleId"] isEqualToString:@"3"]){
             
             if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isAgentProfile"] isEqualToString:@"0"] ||[[[NSUserDefaults standardUserDefaults] valueForKey:@"isAgentProfile"] isEqualToString:@"1"]  ||
                 [[[NSUserDefaults standardUserDefaults] valueForKey:@"isAgentProfile"] isEqualToString:@"2"]) {
                 
                 
                 CreateProfileVC *objCreateProfileVC =[[CreateProfileVC alloc] initWithNibName:@"CreateProfileVC" bundle:nil];
                 self.navController =[[UINavigationController alloc] initWithRootViewController:objCreateProfileVC];
                 [self.window setRootViewController:self.navController];
                 
                 
                 /*RootViewController *objRootVC =[[RootViewController alloc] init];
                  self.navController =[[UINavigationController alloc] initWithRootViewController:objRootVC];*/
                 
             }else{
               
                 [self.window setRootViewController:[Utility CreateAgentTabbar]];
           
             }
           
           }else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"roleId"] isEqualToString:@"2"]){
     
            //goto seller
            [self.window setRootViewController:[Utility createHomeTabbar]];
            
        }else{
            
            StartUpVC *objStartUpVC =[[StartUpVC alloc] initWithNibName:@"StartUpVC" bundle:nil];
            self.navController =[[UINavigationController alloc] initWithRootViewController:objStartUpVC];
            [self.window setRootViewController:self.navController];

        }
    }
    
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setTintColor:[Utility getColor:ORANGE_COLOR]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:OpenSans_Light size:18.0f],
                                                          NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [self.window setTintColor:[Utility getColor:ORANGE_COLOR]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[Utility getColor:ORANGE_COLOR]];
   
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];

}
-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
  
    if (!error) {
        
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *firstname = user.profile.givenName;
        NSString *lastname = user.profile.familyName;
        NSString *email = user.profile.email;
        
        NSDictionary *dictParam =[[NSDictionary alloc] initWithObjectsAndKeys:CHECK_NULL_STRING(userId),@"userId",
                                  CHECK_NULL_STRING(firstname),@"firstname",
                                  CHECK_NULL_STRING(lastname),@"lastname",
                                  CHECK_NULL_STRING(email),@"email",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification"object:nil userInfo:dictParam];

        
        
    }
    
}
-(void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // [START_EXCLUDE]
    
    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification" object:nil userInfo:statusText];
    
    // [END_EXCLUDE]
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    
    NSString* strDeviceToken = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    
    
    NSLog(@"Device Token ===> : %@", strDeviceToken);
    
    [[NSUserDefaults standardUserDefaults] setValue:strDeviceToken forKey:@"storedDeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // [Utility showAlertWithTitle:self.deviceToken withMessage:nil];
    
    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSString  *tempToken=@"b58126d4b6c780dda09888dc28f1cd90161363ac20bf826341216cea8b7b7759";
    [[NSUserDefaults standardUserDefaults] setValue:tempToken forKey:@"storedDeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self updateDeviceTokenForDevice];
    //[Utility showAlertWithTitle:@"Notification" withMessage:@"You have disable notification, to enable it goto Setting->Notifications->EBroker and make it enable"];
    //   [self connectToSocketServer];
    
}

+(AppDelegate *)initAppDelegate
{
    return  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}
-(void)prepareUserDefaults{
   
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"isLogin"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"loginUserId"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginUserId"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"storedDeviceToken"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"storedDeviceToken"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"loginUserId"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginUserId"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"roleId"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"roleId"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"firstName"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"firstName"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"lastName"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lastName"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"loginEmail"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginEmail"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"isAgentProfile"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"isAgentProfile"];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"HomeSpecialization"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"HomeSpecialization"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PriceRanges"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"PriceRanges"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CitiesCovered"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"CitiesCovered"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ZilloProfile"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"ZilloProfile"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PhotoVideo"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"PhotoVideo"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"IntroToSeller"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"IntroToSeller"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ServiceProvide"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"ServiceProvide"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Brokerage"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Brokerage"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"homeTypesIds"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"homeTypesIds"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"priceRangesIds"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"priceRangesIds"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCities"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selectedCities"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"strZilloProfile"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"strZilloProfile"];
    }
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"isQuickIntro"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"isQuickIntro"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"isExpAndEdu"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"isExpAndEdu"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"isFunAndFact"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"isFunAndFact"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"quickIntro"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"quickIntro"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"expAndEdu"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"expAndEdu"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"funAndFact"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"funAndFact"];
    }
    
    
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"serviceTypesIds"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"serviceTypesIds"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"serviceTypesNames"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"serviceTypesNames"];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"BrokerageFirm"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BrokerageFirm"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"BrokerageAddress"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BrokerageAddress"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"BrokerageLandmark"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BrokerageLandmark"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"BrokerageState"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BrokerageState"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"BrokeragePinCode"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BrokeragePinCode"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"BrokeragePhone"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BrokeragePhone"];
    }


    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"videoProfileUrl"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"videoProfileUrl"];
    }
   
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"isLeadsAndListings"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"isLeadsAndListings"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"selectedLeads"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"selectedLeads"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"amountPerLead"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"amountPerLead"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"selectedListings"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"selectedListings"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"amountPerListing"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"amountPerListing"];
    }
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"isPaymentMethod"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"isPaymentMethod"];
    }

    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"CreditCardNumber"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CreditCardNumber"];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"expireDate"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"expireDate"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"securityCode"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"securityCode"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
- (void)registerForNotification {
    
    
    if(SYSTEM_VERSION_GREATER_THAN(@"10.0")){
        
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        // center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else{
        
        
        
        
        if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        
    }
    
}
/*- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"%@",userInfo);
    
    
    if((application.applicationState == UIApplicationStateInactive) ||(application.applicationState == UIApplicationStateBackground) ) {
        
        NSLog(@"Inactive / background");
        
        //Show the view with the content of the push
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        completionHandler(UIBackgroundFetchResultNewData);
        
        
        if ([[userInfo valueForKeyPath:@"aps.type"]isEqualToString:@"order"]) {
            
           
            
        }
        else{
            
            NSLog(@"Other Notification");
        }
        
        
    }
    else {
        
        NSLog(@"Active");
        
        if (application.applicationState == UIApplicationStateActive ) {
            
            [Utility showAlertWithTitle:[userInfo valueForKeyPath:@"aps.title"] withMessage:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]];
            
        }
        //Show an in-app banner
        // [self handleRemoteNotifications:userInfo];
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    }
    
}*/


@end
