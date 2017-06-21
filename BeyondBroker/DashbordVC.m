//
//  DashbordVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 18/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "DashbordVC.h"
#import "MessagesVC.h"
#import "ListingsVC.h"
#import "ProfileVC.h"
#import "Utility.h"
@interface DashbordVC ()

@end

@implementation DashbordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
        ListingsVC *objListingsVC;
        MessagesVC *objMessagesVC;
        ProfileVC *objProfileVC;
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        [tabBarController.tabBar setBarTintColor:[UIColor whiteColor]];
        [tabBarController.tabBar setTintColor:[Utility getColor:BTN_COLOR_LOG]];
        [tabBarController.tabBar setTranslucent:YES];
        
        objListingsVC = [[ListingsVC alloc] initWithNibName:@"ListingsVC" bundle:nil];
        UINavigationController *ListingNavController = [[UINavigationController alloc] initWithRootViewController:objListingsVC];
        ListingNavController.tabBarItem.image = [UIImage imageNamed:@"ic_home.png"];
        ListingNavController.tabBarItem.title = @"Listings";
        
        objMessagesVC = [[MessagesVC alloc] initWithNibName:@"MessagesVC" bundle:nil];
        UINavigationController *MessagesNavController = [[UINavigationController alloc] initWithRootViewController:objMessagesVC];
        MessagesNavController.tabBarItem.image = [UIImage imageNamed:@"ic_message.png"];
        MessagesNavController.tabBarItem.title = @"Messages";
        
        objProfileVC= [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
        UINavigationController *ProfileNavController = [[UINavigationController alloc] initWithRootViewController:objProfileVC];
        ProfileNavController.tabBarItem.image = [UIImage imageNamed:@"ic_profile.png"];
        ProfileNavController.tabBarItem.title = @"Profile";
        tabBarController.viewControllers = @[ListingNavController,MessagesNavController,ProfileNavController];
        
}

@end
