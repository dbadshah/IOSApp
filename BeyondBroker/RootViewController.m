//
//  RootViewController.m
//  BashayerZon
//
//  Created by Sarthak Patel on 07/02/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "RootViewController.h"
#import "CurrentVC.h"
#import "PastVC.h"
#import "Utility.h"
#import "AppDelegate.h"
#define TAB_WIDTH [[UIScreen mainScreen] bounds].size.width/2
@interface RootViewController ()<NKJPagerViewDataSource, NKJPagerViewDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
   
    [self setupMenu];
    //self.navigationItem.title = @"Test";

     //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"verticalDot.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showHomeActionSheet)];

    [self.navigationController.navigationBar setHidden:true];
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];

    self.dataSource = self;
    self.delegate = self;
    self.infiniteSwipe = NO;
    self.activeContentIndex=0;
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupMenu{
   
    self.arrMenu =[[NSMutableArray alloc] initWithObjects:@"Current",@"Past", nil];
    
}


#pragma mark - NKJPagerViewDataSource

- (NSUInteger)numberOfTabView
{
    return self.arrMenu.count;
}

- (UIView *)viewPager:(NKJPagerViewController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, TAB_WIDTH, 52.f)];
    
   // CGFloat r = (arc4random_uniform(255) + 1.f) / 255.0;
    //CGFloat g = (arc4random_uniform(255) + 1.f) / 255.0;
    //CGFloat b = (arc4random_uniform(255) + 1.f) / 255.0;
   // UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    //label.backgroundColor = color;

    label.backgroundColor=[UIColor whiteColor];
    label.font=[UIFont boldSystemFontOfSize:14];
    //label.text = [NSString stringWithFormat:@"Tab #%lu", index * 10];
    label.text = [self.arrMenu objectAtIndex:index];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [Utility getColor:ORANGE_COLOR];
    return label;

}
- (UIViewController *)viewPager:(NKJPagerViewController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    
    switch (index) {
        case 0:
        {
            CurrentVC *objCurrentVC =[[CurrentVC alloc] initWithNibName:@"CurrentVC" bundle:nil];
            return objCurrentVC;
        }
        break;
        case 1:
        {
            PastVC *objPastVC =[[PastVC alloc] initWithNibName:@"PastVC" bundle:nil];
            return objPastVC;
            
        }
        break;
            
        default:
            return nil;
            break;
    }
}
- (CGFloat)widthOfTabViewWithIndex:(NSInteger)index
{
    return TAB_WIDTH;
}

#pragma mark - NKJPagerViewDelegate

- (void)viewPager:(NKJPagerViewController *)viewPager didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs
{
    [UIView animateWithDuration:0.1f
                     animations:^{
                         for (UIView *view in self.tabs) {
                             if (index == view.tag) {
                                 //view.alpha = 0.5f;
                                 UILabel *lbl =(UILabel *)view;
                                 lbl.textColor=[Utility getColor:ORANGE_COLOR];
                                   [[lbl.layer.sublayers firstObject]removeFromSuperlayer];

                                 CALayer *tempLayer =[[CALayer alloc] init];
                                
                                 
                                 tempLayer.frame = CGRectMake(0, lbl.frame.size.height-3.5, lbl.frame.size.width, 3.5);
                                 if (lbl.layer.sublayers.count<1) {
                                      tempLayer.backgroundColor=[Utility getColor:ORANGE_COLOR].CGColor;
                                     [lbl.layer addSublayer:tempLayer];
                                 }
                                 
                                 
                                 } else {
                                 //view.alpha = 1.0f;
                                 
                                 UILabel *lbl =(UILabel *)view;
                                 lbl.textColor=[UIColor grayColor];

                               [[lbl.layer.sublayers firstObject]removeFromSuperlayer];
                                 
                                 CALayer *tempLayer =[[CALayer alloc] init];
                                 
                                 
                                 tempLayer.frame = CGRectMake(0, lbl.frame.size.height-3.5, lbl.frame.size.width, 3.5);
                                     tempLayer.backgroundColor=[UIColor lightGrayColor].CGColor;
                                     [lbl.layer addSublayer:tempLayer];
                                 
                                 
                             }
                         }
                     }
                     completion:^(BOOL finished){}];
}



-(void)switchToIndex:(NSInteger)index
{
    [self switchViewControllerWithIndex:index];
}
@end
