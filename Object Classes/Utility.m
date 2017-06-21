//
//  Utility.m
//  Abjibapa
//
//  Created by Linath Infotech on 17/09/14.
//  Copyright (c) 2014 LinathInfotech. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "ListingsVC.h"
#import "MessagesVC.h"
#import "ProfileVC.h"

#import "AgentAnalysVC.h"
#import "AgentMessageVC.h"
#import "AgentProfileVC.h"

@implementation Utility
+ (UIColor *)getColor:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}
+(void)setNavigationProperties:(UINavigationController *)navController{
    
     navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setBarTintColor:[Utility getColor:NAV_BG_COLOR]];
    [navController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:Helvetica_Neue size:18.0f],
      NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [navController.navigationBar setTranslucent:NO];
    
    
    
}
+(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
+(BOOL)isInternetConnected{
    Reachability *objRechability=[Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [objRechability currentReachabilityStatus];
    if (netStatus==0) {		
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
-(void)showLoadingWithText:(NSString *)loadingText{
    
  /*  objMBProgressHUD = [[MBProgressHUD alloc] initWithView:[AppDelegate initAppDelegate].window];
    
    [[AppDelegate initAppDelegate].window addSubview:objMBProgressHUD];
    objMBProgressHUD.delegate = self;
    objMBProgressHUD.labelText = loadingText;
    objMBProgressHUD.removeFromSuperViewOnHide = YES;
    [objMBProgressHUD show:TRUE];
    // Show the HUD while the provided method executes in a new thread
    //[objMBProgressHUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];*/
    [MRProgressOverlayView showOverlayAddedTo:[AppDelegate initAppDelegate].window title:loadingText mode:MRProgressOverlayViewModeIndeterminateSmall animated:true];
    
    
}
-(void)hideProgress{
    
  //  [objMBProgressHUD hide:TRUE];
    [MRProgressOverlayView dismissAllOverlaysForView:[AppDelegate initAppDelegate].window animated:true];
    
}
+(Utility *)getInstance{
    return [[Utility alloc] init];
}
+(void)showAlertWithTitle:(NSString *)strTitle withMessage:(NSString *)message{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:CHECK_NULL_STRING(strTitle) message:CHECK_NULL_STRING(message) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    UITextField *textField = [alert textFieldAtIndex:0];
    [textField setUserInteractionEnabled:false];
    
    [alert show];
    
}
+(CGSize)getHeightAccordingToText:(NSString *)str withFont:(UIFont *)font withWidth:(float)width {
    
    CGSize size;
    
    size=[str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size  ;
    
    return size;
    
}
+(void)setImageInBackground:(NSString *)imageName inView:(UIView *)view{
    
    
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}
+(void)setBackgroundImageInView:(UIView *)view withImageName:(NSString *)imageName orImage:(UIImage *)passedImage{
    
  /*  NSString *imageName;
    if (iPhone) {
    
        if (IS_IPHONE_4_OR_LESS) {
            imageName=@"user.jpg";
        }
        else if (IS_IPHONE_5)
        {
            imageName=@"user.jpg";
        }
        else if (IS_IPHONE_6)
        {
            imageName=@"user.jpg";
        }
        else if (IS_IPHONE_6P)
        {
            imageName=@"user.jpg";
        }
        else{
            imageName=@"user.jpg";
        }

    }
    else
    {
        imageName=@"user.jpg";
    }*/
    
    UIGraphicsBeginImageContext(view.frame.size);
    
    if(passedImage==nil)
    {
        [[UIImage imageNamed:imageName] drawInRect:view.bounds];
    }
    else{
        [passedImage drawInRect:view.bounds];
    }
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bluredEffectView setFrame:view.bounds];
    
    [view addSubview:bluredEffectView];
    
    [view sendSubviewToBack:bluredEffectView];
    
    //[view setMaskView:bluredEffectView];
    
    
}



/*- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
   
 
 // to use this do  #import <objc/runtime.h>

 //this method gives you dictionary from any custom class.(eg. if you want Person class then it takes person class variable name as dictionary key and value as variable value)
 
 NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}*/

+(NSDate *)getDateFromString:(NSString *)strDate withFormat:(NSString *)format
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:format];
    
    NSDate *dateTemp = [dateFormatter dateFromString:strDate];
    return dateTemp;

}
+(NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
   // NSLog(@"%@",stringFromDate);
    return stringFromDate;
}
+(BOOL)compareTwoImage:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

+(UIImage *)resizeImage:(UIImage *)origionalImage
{
    CGFloat oldHeight =origionalImage.size.height;
    CGFloat oldWidth =origionalImage.size.width;
    
    
    NSLog(@"old Height %f",oldHeight);
    NSLog(@"old Height %f",oldWidth);
    
    CGFloat newHeight =250;
    CGFloat newWidth =(oldWidth * 250)/oldHeight;
    
    CGRect rect = CGRectMake(0,0,newWidth,newHeight);
    UIGraphicsBeginImageContext( rect.size );
    [origionalImage drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    
    NSLog(@"new width %f",img.size.width);
    NSLog(@"new Height %f",img.size.height);
    
    return img;
}
+(UIImage *)resizeChatImage:(UIImage *)origionalImage
{
    CGFloat oldHeight =origionalImage.size.height;
    CGFloat oldWidth =origionalImage.size.width;
    
    
    NSLog(@"old Height %f",oldHeight);
    NSLog(@"old Height %f",oldWidth);
    
    CGFloat newHeight=oldHeight;
    CGFloat newWidth=oldWidth;
    
    if (oldHeight>800) {
        
        newHeight =800;
        newWidth =(oldWidth * 800)/oldHeight;
    }
    
    CGRect rect = CGRectMake(0,0,newWidth,newHeight);
    UIGraphicsBeginImageContext( rect.size );
    [origionalImage drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(picture1,1.0);
    UIImage *img=[UIImage imageWithData:imageData];
    
    NSLog(@"new width %f",img.size.width);
    NSLog(@"new Height %f",img.size.height);
    
    return img;
}
+(UIImage *)resizeChatThumbImage:(UIImage *)origionalImage
{
    CGFloat oldHeight =origionalImage.size.height;
    CGFloat oldWidth =origionalImage.size.width;
    
    
    NSLog(@"old Height %f",oldHeight);
    NSLog(@"old Height %f",oldWidth);
    
    
    
        
     CGFloat   newHeight =50;
    CGFloat  newWidth =(oldWidth * 50)/oldHeight;
    
    
    CGRect rect = CGRectMake(0,0,newWidth,newHeight);
    UIGraphicsBeginImageContext( rect.size );
    [origionalImage drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(picture1,1.0);
    UIImage *img=[UIImage imageWithData:imageData];
    
    NSLog(@"new width %f",img.size.width);
    NSLog(@"new Height %f",img.size.height);
    
    return img;
}


+(NSString *)getDateFromTimeInterval:(NSString *)timeInterval dateFormat:(NSString *)dateFormat{
    

    double getDate=[timeInterval doubleValue]; // here replace your value
   // NSTimeInterval seconds = getDate / 1000;
    NSTimeInterval seconds = getDate;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:dateFormat];
    
   // @"dd-MMM-yyyy hh:mm a"
    //[dateFormatter setDateFormat:@"dd MMM,yyyy hh:mm:ss a"];
    return [dateFormatter stringFromDate:date];
    
}

+(UIImage *)getImageFromCache:(NSString *)imagePath withPlaceHolderImage:(NSString *)imageName;
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    
    UIImage *img= [imageCache imageFromDiskCacheForKey:imagePath];
    
    if (img) {
        return img;
    }
    else{
        return [UIImage imageNamed:imageName];
    }
}

+(BOOL)isLastDayOfMonth:(NSDate *)selectedDate{
    
    NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:today];
    
    
    NSDate *currentDate = selectedDate;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    [components month]; //gives you month
    [components day]; //gives you day
    [components year];
    
    

    if([components day]==days.length)
        return TRUE;
    else
        return false;
    
}
+(UITabBarController *)createHomeTabbar{
    
    ListingsVC *objListingsVC;
    MessagesVC *objMessagesVC;
    ProfileVC *objProfileVC;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setBarTintColor:[UIColor whiteColor]];
   // [tabBarController.tabBar setTintColor:[Utility getColor:BTN_COLOR_LOG]];
    [tabBarController.tabBar setTranslucent:YES];
    
    objListingsVC = [[ListingsVC alloc] initWithNibName:@"ListingsVC" bundle:nil];
    UINavigationController *ListingNavController = [[UINavigationController alloc] initWithRootViewController:objListingsVC];
    ListingNavController.tabBarItem.image = [UIImage imageNamed:@"analysis_unselected.png"];
    ListingNavController.tabBarItem.selectedImage=[UIImage imageNamed:@"analysis_selected.png"];
    ListingNavController.tabBarItem.title = @"Listings";
    
    objMessagesVC = [[MessagesVC alloc] initWithNibName:@"MessagesVC" bundle:nil];
    UINavigationController *MessagesNavController = [[UINavigationController alloc] initWithRootViewController:objMessagesVC];
    MessagesNavController.tabBarItem.image = [UIImage imageNamed:@"message_unselected.png"];
    MessagesNavController.tabBarItem.selectedImage=[UIImage imageNamed:@"message_selected.png"];
    MessagesNavController.tabBarItem.title = @"Messages";
    
    objProfileVC= [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
    UINavigationController *ProfileNavController = [[UINavigationController alloc] initWithRootViewController:objProfileVC];
    ProfileNavController.tabBarItem.image = [UIImage imageNamed:@"profile_selected.png"];
    ProfileNavController.tabBarItem.selectedImage=[UIImage imageNamed:@"profile_unselected.png"];
    ProfileNavController.tabBarItem.title = @"Profile";
    
    tabBarController.viewControllers = @[ListingNavController,MessagesNavController,ProfileNavController];
    
    return tabBarController;
    
}
+(UITabBarController *)CreateAgentTabbar{
    
    
    AgentAnalysVC *objListingsVC;
    AgentMessageVC *objMessagesVC;
    AgentProfileVC *objProfileVC;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setBarTintColor:[UIColor whiteColor]];
   // [tabBarController.tabBar setTintColor:[Utility getColor:BTN_COLOR_LOG]];
    [tabBarController.tabBar setTranslucent:YES];
    
    objListingsVC = [[AgentAnalysVC alloc] initWithNibName:@"AgentAnalysVC" bundle:nil];
    UINavigationController *ListingNavController = [[UINavigationController alloc] initWithRootViewController:objListingsVC];
    ListingNavController.tabBarItem.image = [UIImage imageNamed:@"analysis_unselected.png"];
    ListingNavController.tabBarItem.selectedImage=[UIImage imageNamed:@"analysis_selected.png"];
    ListingNavController.tabBarItem.title = @"Listings";
    
    objMessagesVC = [[AgentMessageVC alloc] initWithNibName:@"AgentMessageVC" bundle:nil];
    UINavigationController *MessagesNavController = [[UINavigationController alloc] initWithRootViewController:objMessagesVC];
    MessagesNavController.tabBarItem.image = [UIImage imageNamed:@"message_unselected.png"];
    MessagesNavController.tabBarItem.selectedImage=[UIImage imageNamed:@"message_selected.png"];
    MessagesNavController.tabBarItem.title = @"Messages";
    
    objProfileVC= [[AgentProfileVC alloc] initWithNibName:@"AgentProfileVC" bundle:nil];
    UINavigationController *ProfileNavController = [[UINavigationController alloc] initWithRootViewController:objProfileVC];
    ProfileNavController.tabBarItem.image = [UIImage imageNamed:@"profile_selected.png"];
    ProfileNavController.tabBarItem.selectedImage=[UIImage imageNamed:@"profile_unselected.png"];
    ProfileNavController.tabBarItem.title = @"Profile";
    
    tabBarController.viewControllers = @[ListingNavController,MessagesNavController,ProfileNavController];
    
    return tabBarController;
}
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}
+(NSDate *)getFirstDateOfCurrentYear
{
    //Get current year
    NSDate *currentYear=[[NSDate alloc]init];
    currentYear=[NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    NSString *currentYearString = [formatter1 stringFromDate:currentYear];
    
    //Get first date of current year
    NSString *firstDateString=[NSString stringWithFormat:@"10 01-01-%@",currentYearString];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"hh dd-MM-yyyy"];
    NSDate *firstDate = [[NSDate alloc]init];
    firstDate = [formatter2 dateFromString:firstDateString];
    
    return firstDate;
}
+(NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}
+ (NSString *)getMonthFromDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    
    /* NSString *month =@"";
     switch (dateComps.month) {
     case 1:
     month=[NSString stringWithFormat:@"January - %ld",[dateComps year]];
     break;
     case 2:
     month=[NSString stringWithFormat:@"February - %ld",[dateComps year]];
     break;
     case 3:
     month=[NSString stringWithFormat:@"March - %ld",[dateComps year]];
     break;
     case 4:
     month=[NSString stringWithFormat:@"April - %ld",[dateComps year]];
     break;
     case 5:
     month=[NSString stringWithFormat:@"May - %ld",[dateComps year]];
     break;
     case 6:
     month=[NSString stringWithFormat:@"June - %ld",[dateComps year]];
     break;
     case 7:
     month=[NSString stringWithFormat:@"July - %ld",[dateComps year]];
     break;
     case 8:
     month=[NSString stringWithFormat:@"August - %ld",[dateComps year]];
     break;
     case 9:
     month=[NSString stringWithFormat:@"September - %ld",[dateComps year]];
     break;
     case 10:
     month=[NSString stringWithFormat:@"October - %ld",[dateComps year]];
     break;
     case 11:
     month=[NSString stringWithFormat:@"November - %ld",[dateComps year]];
     break;
     case 12:
     month=[NSString stringWithFormat:@"December - %ld",[dateComps year]];
     break;
     
     default:
     break;
     }*/
    
    return [NSString stringWithFormat:@"%ld",(long)dateComps.month];
}
+(NSString *)getYearFromDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    
    return [NSString stringWithFormat:@"%ld",(long)[dateComps year]];
    
    
    
    
}
+(NSString *)timeFormatted:(NSString *)sec
{
    int totalSeconds=[sec intValue];
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if(hours>0)
    {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
    else{
     
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
}


+(UIImage*) scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
}

- (UIImage*) reOrientIfNeeded:(UIImage*)theImage{
    
    if (theImage.imageOrientation != UIImageOrientationUp) {
        
        CGAffineTransform reOrient = CGAffineTransformIdentity;
        switch (theImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, theImage.size.height);
                reOrient = CGAffineTransformRotate(reOrient, M_PI);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, 0);
                reOrient = CGAffineTransformRotate(reOrient, M_PI_2);
                break;
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, 0, theImage.size.height);
                reOrient = CGAffineTransformRotate(reOrient, -M_PI_2);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                break;
        }
        
        switch (theImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, 0);
                reOrient = CGAffineTransformScale(reOrient, -1, 1);
                break;
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.height, 0);
                reOrient = CGAffineTransformScale(reOrient, -1, 1);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationDown:
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                break;
        }
        
        CGContextRef myContext = CGBitmapContextCreate(NULL, theImage.size.width, theImage.size.height, CGImageGetBitsPerComponent(theImage.CGImage), 0, CGImageGetColorSpace(theImage.CGImage), CGImageGetBitmapInfo(theImage.CGImage));
        
        CGContextConcatCTM(myContext, reOrient);
        
        switch (theImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                CGContextDrawImage(myContext, CGRectMake(0,0,theImage.size.height,theImage.size.width), theImage.CGImage);
                break;
                
            default:
                CGContextDrawImage(myContext, CGRectMake(0,0,theImage.size.width,theImage.size.height), theImage.CGImage);
                break;
        }
        
        CGImageRef CGImg = CGBitmapContextCreateImage(myContext);
        theImage = [UIImage imageWithCGImage:CGImg];
        
        CGImageRelease(CGImg);
        CGContextRelease(myContext);
    }
    
    return theImage;
}

+(void)setSlidePanelButton:(JDSideMenu *)jdSideMenu
{
    if (![jdSideMenu isMenuVisible]) {
        [jdSideMenu showMenuAnimated:YES];
    } else {
        [jdSideMenu hideMenuAnimated:YES];
    }
    
}
UIView *view;
+(void)showBlankView:(UIView *)controllerView{
    
    
    
    if (!view) {
        view=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        [view setBackgroundColor:[UIColor blackColor]];
        [view setAlpha:0.5];
    }
    
    [controllerView addSubview:view];
    
    
}
+(void)hideBlankView{
    
    [view removeFromSuperview];
}

+(BOOL) isValidPassword:(NSString *)pwd {
    
    //NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    
    //NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if ( [pwd length]<8)
        return NO;  // too long or too short
    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
        return NO;  // no letter
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )
        return NO;  // no number;
    //    rang = [pwd rangeOfCharacterFromSet:upperCaseChars];
    //    if ( !rang.length )
    //        return NO;  // no uppercase letter;
    rang = [pwd rangeOfCharacterFromSet:lowerCaseChars];
    if ( !rang.length )
        return NO;  // no lowerCase Chars;
    return YES;
}
+(void)removeAllUserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
@end


