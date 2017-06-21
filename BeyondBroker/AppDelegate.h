//
//  AppDelegate.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 04/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <GoogleSignIn/GoogleSignIn.h>

#define DEVICE_TOKEN [[NSUserDefaults standardUserDefaults] valueForKey:@"storedDeviceToken"]

#define USER_ID [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]

#define ROAL_ID [[NSUserDefaults standardUserDefaults] valueForKey:@"roleId"]

#define FIRST_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"firstName"]
#define LAST_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"lastName"]
#define EMAIL [[NSUserDefaults standardUserDefaults] valueForKey:@"loginEmail"]

#define APP_WINDOW [AppDelegate initAppDelegate].window

#define STATIC_TOKEN @"1920573288"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) UINavigationController *navController;
+(AppDelegate *)initAppDelegate;

@end

