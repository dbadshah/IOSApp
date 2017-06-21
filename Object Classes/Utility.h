//
//  Utility.h
//  Abjibapa
//
//  Created by Linath Infotech on 17/09/14.
//  Copyright (c) 2014 LinathInfotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import <AudioToolbox/AudioServices.h>
#import <MRProgress/MRProgress.h>
#import "JDSideMenu.h"



//#define MAIN_URL @"http://beyondbroker.atozenterprise.co.in/"

#define MAIN_URL @"http://beyondbroker.ssvent.com/"


#define CurrentTimeStamp [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]]

#define GetTimeStampFromDate(date) [NSString stringWithFormat:@"%0.0f",[date timeIntervalSince1970]]

#define DEVICE_ID [[[UIDevice currentDevice] identifierForVendor]UUIDString]

#define STORED_DEVICE_TOKEN [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"]

#define UserDefault [NSUserDefaults standardUserDefaults]


#define NAV_BG_COLOR @"E17300" //FF8800 //F9A61A
#define BTN_BG_COLOR @"E17300" //006bca
#define TEXT_COLOR @"464646"
#define SECTION_BG_COLOR @"f4f4f4"
//#define GREEN_COLOR @"7ec47b"
#define GREEN_COLOR @"76B62E"
#define SHADOW_COLOR @"d7d7d7"
#define BROWN_COLOR @"FB5A29"
#define ORANGE_COLOR @"FF755B"
#define DARKBLUE_COLOR @"3D879F"
#define BTN_COLOR_LOG @"ff755b"
#define GRAY_COLOR @"888888"
#define YELLOW_COLOR @"F5A623"


#define IS_LOGIN @"isLogin"

#define IS_EDIT @"isEditProperty"


//step 1
#define HOME_BATH @"home_bath"
#define HOME_BED @"home_bed"
#define HOME_ID @"home_id"
#define YEAR_BUILT @"Year_Built"
#define SQFT @"sqft"
#define ADDRESS @"address"
#define USECODE @"useCode"
#define CITY @"city"
#define STATE @"state"
#define ZIPCODE @"zipcode"


//step 2
#define TIMELINE_ID @"timeline_id"
#define TIMELINE @"timeline"
#define REASON_FOR_SELLING @"reason_for_selling"
#define HOME_COMMENT @"home_comment"
#define KIND_OF_AGENT @"kind_of_agent_looking_for"


#define PROPERTY_ID @"property_id"




#define SERVER_ERROR_MSG @"Failed to fetch data, please try again later!"

//#define CHECK_NULL_STRING(str) ([str isKindOfClass:[NSNull class]] || !str)?@"":str

#define CHECK_NULL_STRING(str) ([str isKindOfClass:[NSNull class]] || !str)?@"":[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

#define DB_CHECK_NULL_STRING(str) ([str isKindOfClass:[NSNull class]] || !str)?@"":[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]




#define iPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define Helvetica_Light @"HelveticaNeue-Light"
#define Helvetica_Medium @"HelveticaNeue-Medium"
#define Helvetica_Neue @"HelveticaNeue"
#define Helvetica_Neue_Bold @"HelveticaNeue-Bold"

#define Helvetica_LT @"HelveticaLT"
#define Helvetica_LT_Bold @"HelveticaLT-Bold"
#define Helvetica_LT_Light @"HelveticaLT-Light"
#define Helvetica_LT_Condensed @"HelveticaLT-Condensed"

#define OpenSans_Semibold @"OpenSans-Semibold"
#define OpenSans_Light @"OpenSans-Light"
#define OpenSans_Regular @"OpenSans"
#define OpenSans_Bold @"OpenSans-Bold"

#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define DOCUMENTPATH_FILE(str) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:str]


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)





#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define NO_INTERNET_TITLE @"No Internet Connection"
#define NO_INTERNET_MSG @"You are not connected to internet, check your internet connection!"
#define LOADING_TITLE @"Loading.."

#define IS_ENG [Utility isEnglishLangSelected]

@interface Utility : NSObject<MBProgressHUDDelegate,UIActionSheetDelegate>
{
     MBProgressHUD *objMBProgressHUD;
     NSTimer* vibrateTimer;
    
    
}
@property(strong,nonatomic)IBOutlet UILabel *lblNotfTitle;
@property(strong,nonatomic)IBOutlet UILabel *lblNotfMsg;
@property(strong,nonatomic)IBOutlet UIImageView *notfImageView;
@property(strong,nonatomic)UIActionSheet *actHomeOption;;

+(UIColor *)getColor:(NSString *)stringToConvert;
+(void)setNavigationProperties:(UINavigationController *)navController;

+(BOOL) isValidEmail:(NSString *)checkString;
+(Utility *)getInstance;
+(BOOL)isInternetConnected;
-(void)showLoadingWithText:(NSString *)loadingText;
-(void)hideProgress;
+(void)showAlertWithTitle:(NSString *)strTitle withMessage:(NSString *)message;
+(CGSize)getHeightAccordingToText:(NSString *)str withFont:(UIFont *)font withWidth:(float)width;
+(void)setImageInBackground:(NSString *)imageName inView:(UIView *)view;
+(void)setBackgroundImageInView:(UIView *)view withImageName:(NSString *)imageName orImage:(UIImage *)passedImage;
+(void)showBlankView:(UIView *)controllerView;
+(void)hideBlankView;
+(NSDate *)getDateFromString:(NSString *)strDate withFormat:(NSString *)format;
+(NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format;

+ (BOOL)compareTwoImage:(UIImage *)image1 isEqualTo:(UIImage *)image2;
+(UIImage *)resizeImage:(UIImage *)origionalImage;
+(UIImage *)resizeChatImage:(UIImage *)origionalImage;
+(UIImage *)resizeChatThumbImage:(UIImage *)origionalImage;
+(NSString *)getDateFromTimeInterval:(NSString *)timeInterval dateFormat:(NSString *)dateFormat;
+(UIImage *)getImageFromCache:(NSString *)imagePath withPlaceHolderImage:(NSString *)imageName;
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
+(NSDate *)getFirstDateOfCurrentYear;
+(NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate;
+ (NSString *)getMonthFromDate:(NSDate *)inputDate;
+(NSString *)getYearFromDate:(NSDate *)inputDate;
+ (NSString *)timeFormatted:(NSString *)sec;


+(void)setSlidePanelButton:(JDSideMenu *)jdSideMenu;
+(void)SettingLastSelectedLanguage;
+(void)changeLanguage:(NSString *)lang;
+(BOOL)isEnglishLangSelected;
+(UITabBarController *)createHomeTabbar;
+(UITabBarController *)CreateAgentTabbar;
+(BOOL) isValidPassword:(NSString *)pwd;
+(void)removeAllUserDefaults;
@end
