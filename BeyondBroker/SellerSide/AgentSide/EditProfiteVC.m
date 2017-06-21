//
//  EditProfiteVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "EditProfiteVC.h"
#import "NameAndPhotoVC.h"
#import "IntroDetailVC.h"
#import "ServiceProvideVC.h"
#import "VideoUrlVC.h"
#import "ServicesCell.h"
#import "HomeTypesCell.h"
#import <UIKit/UIKit.h>
#import "HCYoutubeParser.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"

typedef void(^DrawRectBlock)(CGRect rect);

@interface HCView : UIView {
@private
    DrawRectBlock block;
}

- (void)setDrawRectBlock:(DrawRectBlock)b;

@end

@interface UIView (DrawRect)
+ (UIView *)viewWithFrame:(CGRect)frame drawRect:(DrawRectBlock)block;
@end

@implementation HCView

- (void)setDrawRectBlock:(DrawRectBlock)b {
    block = [b copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (block)
        block(rect);
}

@end

@implementation UIView (DrawRect)

+ (UIView *)viewWithFrame:(CGRect)frame drawRect:(DrawRectBlock)block {
    HCView *view = [[HCView alloc] initWithFrame:frame];
    [view setDrawRectBlock:block];
    return view;
}
@end

@interface EditProfiteVC (){
    NSURL *_urlToLoad;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@end

@implementation EditProfiteVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setHidden:true];
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
 
    screenWidth=[[UIScreen mainScreen] bounds].size.width;
    cellSize = CGSizeMake((screenWidth/2)-13,20);
    [self.objCollectionView registerNib:[UINib nibWithNibName:@"ServicesCell" bundle:nil] forCellWithReuseIdentifier:@"ServicesCell"];
    self.arrData=[[NSMutableArray alloc]init];
    
    
//    UIView *grainView = [UIView viewWithFrame:self.view.bounds drawRect:^(CGRect rect) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        [[UIColor colorWithHue:0.000 saturation:0.000 brightness:0.773 alpha:1] setFill];
//        CGContextFillRect(context, rect);
//        
//        static CGImageRef noiseImageRef = nil;
//        static dispatch_once_t oncePredicate;
//        dispatch_once(&oncePredicate, ^{
//            NSUInteger width = 128, height = width;
//            NSUInteger size = width*height;
//            char *rgba = (char *)malloc(size); srand(115);
//            for(NSUInteger i=0; i < size; ++i){rgba[i] = rand()%256;}
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//            CGContextRef bitmapContext =
//            CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, kCGBitmapByteOrderDefault);
//            CFRelease(colorSpace);
//            noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
//            CFRelease(bitmapContext);
//            free(rgba);
//        });
//        
//        CGContextSaveGState(context);
//        CGContextSetAlpha(context, 0.5);
//        CGContextSetBlendMode(context, kCGBlendModeScreen);
//        
//        if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//            CGFloat scaleFactor = [[UIScreen mainScreen] scale];
//            CGContextScaleCTM(context, 1/scaleFactor, 1/scaleFactor);
//        }
//        
//        CGRect imageRect = (CGRect){CGPointZero, CGImageGetWidth(noiseImageRef), CGImageGetHeight(noiseImageRef)};
//        CGContextDrawTiledImage(context, imageRect, noiseImageRef);
//        CGContextRestoreGState(context);
//    }];
//    
//    [self.view insertSubview:grainView atIndex:0];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
  
    //http://beyondbroker.atozenterprise.co.in/Agent_Webservice/agent_edit_profile_details
    
    NSString *post = [NSString stringWithFormat: @"token=%@&userid=%@",STATIC_TOKEN,USER_ID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_edit_profile_details"] withData:postData withMehtod:@"POST" withLoadingAlert:LOADING_TITLE withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                NSLog(@"%@",dict);
                
                // [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"userid"] forKey:@"loginUserId"];
                //[[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }else{
                
                [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                return;
            }
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];

    
    NSString *serviceTypesNames =[UserDefault valueForKey:@"serviceTypesNames"];
    self.arrData = [serviceTypesNames componentsSeparatedByString:@","];
    [self.objCollectionView reloadData];
    
    NSString *urlstr=[NSString stringWithFormat:@"https://www.youtube.com/watch?v=k500CJruYjE"];
    NSString *formattedString = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    _playButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _playButton.layer.shadowOffset = CGSizeMake(0, 0);
    _playButton.layer.shadowOpacity = 0.7;
    _playButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:_playButton.bounds].CGPath;
    _playButton.layer.shadowRadius = 2;
    
    
    _urlToLoad = nil;
    [_playButton setImage:nil forState:UIControlStateNormal];
    
    NSURL *url = [NSURL URLWithString:formattedString];
    _activityIndicator.hidden = NO;
    [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
        
        if (!error) {
            [_playButton setBackgroundImage:image forState:UIControlStateNormal];
            
            [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                
                _playButton.hidden = NO;
                _activityIndicator.hidden = YES;
                
                NSDictionary *qualities = videoDictionary;
                
                NSString *URLString = nil;
                if ([qualities objectForKey:@"small"] != nil) {
                    URLString = [qualities objectForKey:@"small"];
                }
                else if ([qualities objectForKey:@"live"] != nil) {
                    URLString = [qualities objectForKey:@"live"];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                    return;
                }
                _urlToLoad = [NSURL URLWithString:URLString];
                
                [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    
}
- (void)playVideo:(id)sender {
    if (_urlToLoad) {
        
        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:_urlToLoad];
        [self presentViewController:mp animated:YES completion:NULL];
        
    }
}
-(IBAction)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)btnEditNameAndPhotoClick:(id)sender {
    
    NameAndPhotoVC *objNameAndPhotoVC =[[NameAndPhotoVC alloc] initWithNibName:@"NameAndPhotoVC" bundle:nil];
    [self.navigationController pushViewController:objNameAndPhotoVC animated:true];

}
- (IBAction)btnEditIntrolClick:(id)sender {
    IntroDetailVC *objIntroDetailVC =[[IntroDetailVC alloc] initWithNibName:@"IntroDetailVC" bundle:nil];
    objIntroDetailVC.optionSelected=0;
    [self.navigationController pushViewController:objIntroDetailVC animated:true];
    
}
- (IBAction)btnEditExprinceAndEducationClick:(id)sender {
    
    IntroDetailVC *objIntroDetailVC =[[IntroDetailVC alloc] initWithNibName:@"IntroDetailVC" bundle:nil];
    objIntroDetailVC.optionSelected=1;
    [self.navigationController pushViewController:objIntroDetailVC animated:true];
    
}
- (IBAction)btnEditAboutMe:(id)sender {
    
    IntroDetailVC *objIntroDetailVC =[[IntroDetailVC alloc] initWithNibName:@"IntroDetailVC" bundle:nil];
    objIntroDetailVC.optionSelected=3;
    [self.navigationController pushViewController:objIntroDetailVC animated:true];

}
- (IBAction)btnVideoEditClick:(id)sender {
    
    VideoUrlVC *objServiceProvideVC =[[VideoUrlVC alloc] initWithNibName:@"VideoUrlVC" bundle:nil];
    [self.navigationController pushViewController:objServiceProvideVC animated:true];
}
- (IBAction)btnServicesClick:(id)sender {
    
    ServiceProvideVC *objServiceProvideVC =[[ServiceProvideVC alloc] initWithNibName:@"ServiceProvideVC" bundle:nil];
    [self.navigationController pushViewController:objServiceProvideVC animated:true];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ServicesCell";
    ServicesCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.lblTitle setFont:[UIFont systemFontOfSize:12]];
    cell.lblTitle.text=[self.arrData objectAtIndex:indexPath.row];
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return cellSize;
}
@end
