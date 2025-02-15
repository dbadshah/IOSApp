//
//  JDSideMenu.m
//  StatusBarTest
//
//  Created by Markus Emrich on 11/11/13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//

#import "JDSideMenu.h"
#import "Utility.h"

// constants
const CGFloat JDSideMenuMinimumRelativePanDistanceToOpen = 0.33;
const CGFloat JDSideMenuDefaultMenuWidth = 250.0;
const CGFloat JDSideMenuDefaultMenuWidth_ipad = 310.0;
const CGFloat JDSideMenuDefaultDamping = 0.6;

// animation times
const CGFloat JDSideMenuDefaultOpenAnimationTime = 1.0;
const CGFloat JDSideMenuDefaultCloseAnimationTime = 0.3;

@interface JDSideMenu ()
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation JDSideMenu

- (id)initWithContentController:(UIViewController*)contentController
                 menuController:(UIViewController*)menuController;
{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _contentController = contentController;
        _menuController = menuController;
        
        _menuWidth =iPhone?JDSideMenuDefaultMenuWidth:JDSideMenuDefaultMenuWidth_ipad;
        _tapGestureEnabled = YES;
        _panGestureEnabled = YES;
    }
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    // add childcontroller
    [self addChildViewController:self.menuController];
    [self.menuController didMoveToParentViewController:self];
    [self addChildViewController:self.contentController];
    [self.contentController didMoveToParentViewController:self];
    
    // add subviews
    _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:self.contentController.view];
    self.contentController.view.frame = self.containerView.bounds;
    self.contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_containerView];
    
    // setup gesture recognizers
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];

    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
   // [self.containerView addGestureRecognizer:self.tapRecognizer];
   //[self.containerView addGestureRecognizer:self.panRecognizer];
}

- (void)setBackgroundImage:(UIImage*)image;
{
    if (!self.backgroundView && image) {
        self.backgroundView = [[UIImageView alloc] initWithImage:image];
        self.backgroundView.frame = self.view.bounds;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:self.backgroundView atIndex:0];
    } else if (image == nil) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
    } else {
        self.backgroundView.image = image;
    }
}

#pragma mark controller replacement

- (void)setContentController:(UIViewController*)contentController
                    animated:(BOOL)animated;
{
    if (contentController == nil) return;
    UIViewController *previousController = self.contentController;
    _contentController = contentController;
    
    // add childcontroller
    [self addChildViewController:self.contentController];
    
    // add subview
    self.contentController.view.frame = self.containerView.bounds;
    self.contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // animate in
    __weak typeof(self) blockSelf = self;
   // CGFloat offset = (iPhone?JDSideMenuDefaultMenuWidth:JDSideMenuDefaultMenuWidth_ipad) + (self.view.frame.size.width-(iPhone?JDSideMenuDefaultMenuWidth:JDSideMenuDefaultMenuWidth_ipad))/2.0;
    CGFloat offset;
    if (iPhone) {
        offset = (iPhone?JDSideMenuDefaultMenuWidth:JDSideMenuDefaultMenuWidth_ipad) + (self.view.frame.size.width-(iPhone?JDSideMenuDefaultMenuWidth:JDSideMenuDefaultMenuWidth_ipad))/2.0;
        
    }
    else{
        offset = 100 + (self.view.frame.size.width-100)/2.0;
    }
    
    [UIView animateWithDuration:JDSideMenuDefaultCloseAnimationTime/2.0 animations:^{
        blockSelf.containerView.transform = CGAffineTransformMakeTranslation(offset, 0);
     //   [blockSelf statusBarView].transform = blockSelf.containerView.transform;
    } completion:^(BOOL finished) {
        // move to container view
        [blockSelf.containerView addSubview:self.contentController.view];
        [blockSelf.contentController didMoveToParentViewController:blockSelf];
        
        // remove old controller
        [previousController willMoveToParentViewController:nil];
        [previousController removeFromParentViewController];
        [previousController.view removeFromSuperview];
        
        [blockSelf hideMenuAnimated:YES];
    }];
}

#pragma mark Animation

- (void)tapRecognized:(UITapGestureRecognizer*)recognizer
{
    
    if (!self.tapGestureEnabled) return;
    
    [recognizer.view endEditing:TRUE];

    if (![self isMenuVisible]) {
        [self showMenuAnimated:YES];
    } else {
        [self hideMenuAnimated:YES];
    }
}

- (void)panRecognized:(UIPanGestureRecognizer*)recognizer
{
    if (!self.panGestureEnabled) return;
    
    [recognizer.view endEditing:TRUE];
    
    
    if ([self.contentController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav =(UINavigationController *)self.contentController;
        if ([nav.viewControllers count]>1) {
            return;
        }
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        return;
    }

    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self addMenuControllerView];
            [recognizer setTranslation:CGPointMake(recognizer.view.frame.origin.x, 0) inView:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [recognizer.view setTransform:CGAffineTransformMakeTranslation(MAX(0,translation.x), 0)];
            //[self statusBarView].transform = recognizer.view.transform;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (velocity.x > 5.0 || (velocity.x >= -1.0 && translation.x > JDSideMenuMinimumRelativePanDistanceToOpen*self.menuWidth)) {
                CGFloat transformedVelocity = velocity.x/ABS(self.menuWidth - translation.x);
                CGFloat duration = JDSideMenuDefaultOpenAnimationTime * 0.66;
                [self showMenuAnimated:YES duration:duration initialVelocity:transformedVelocity];
            } else {
                [self hideMenuAnimated:YES];
            }
        }
        default:
            break;
    }
}

- (void)addMenuControllerView;
{
    if (self.menuController.view.superview == nil) {
        CGRect menuFrame, restFrame;
        CGRectDivide(self.view.bounds, &menuFrame, &restFrame, self.menuWidth, CGRectMinXEdge);
        self.menuController.view.frame = menuFrame;
        self.menuController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = self.menuController.view.backgroundColor;
        if (self.backgroundView) [self.view insertSubview:self.menuController.view aboveSubview:self.backgroundView];
        else [self.view insertSubview:self.menuController.view atIndex:0];
    }
}

- (void)showMenuAnimated:(BOOL)animated;
{
    [self showMenuAnimated:animated duration:JDSideMenuDefaultOpenAnimationTime
           initialVelocity:1.0];
}

- (void)showMenuAnimated:(BOOL)animated duration:(CGFloat)duration
         initialVelocity:(CGFloat)velocity;
{
    // add menu view
    [self addMenuControllerView];
    
    
    // animate
    __weak typeof(self) blockSelf = self;
    [UIView animateWithDuration:animated ? duration : 0.0 delay:0
         usingSpringWithDamping:JDSideMenuDefaultDamping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
             blockSelf.containerView.transform = CGAffineTransformMakeTranslation(self.menuWidth, 0);
           
             
              if (self.contentController.childViewControllers.count>1) {
                
                  //for tabbar handling
                  
                  UITabBarController *tabbarController =(UITabBarController *)self.contentController;
                  
                 // NSLog(@"%ld is the tabbar item",tabbarController.selectedIndex);
                  
                  [[[[self.contentController.childViewControllers objectAtIndex:tabbarController.selectedIndex].childViewControllers objectAtIndex:0] view] addGestureRecognizer:self.tapRecognizer];
                  
                  
                // [[[self.contentController.childViewControllers objectAtIndex:1] view] addGestureRecognizer:self.tapRecognizer];
                  
                  
 
             }
             else{
                // NSLog(@"%@",[self.contentController.childViewControllers objectAtIndex:0]);

                 //NSLog(@"%@",self.contentController);
                 
                 [[[self.contentController.childViewControllers objectAtIndex:0] view] addGestureRecognizer:self.tapRecognizer];

             }
             
            // [self statusBarView].transform = blockSelf.containerView.transform;
         } completion:nil];
}



- (void)hideMenuAnimated:(BOOL)animated;
{
    __weak typeof(self) blockSelf = self;
    [UIView animateWithDuration:JDSideMenuDefaultCloseAnimationTime animations:^{
        blockSelf.containerView.transform = CGAffineTransformIdentity;
     //   [self statusBarView].transform = blockSelf.containerView.transform;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClosePanelNotification" object:nil];

    } completion:^(BOOL finished) {
        [blockSelf.menuController.view removeFromSuperview];
       //[self.containerView.superview removeGestureRecognizer:self.tapRecognizer];
       
        
        
        
        if (self.contentController.childViewControllers.count>1) {
            
            //for tabbar handling
            
            UITabBarController *tabbarController =(UITabBarController *)self.contentController;
            
            // NSLog(@"%ld is the tabbar item",tabbarController.selectedIndex);
            
            [[[[self.contentController.childViewControllers objectAtIndex:tabbarController.selectedIndex].childViewControllers objectAtIndex:0] view] removeGestureRecognizer:self.tapRecognizer];
            
            
            // [[[self.contentController.childViewControllers objectAtIndex:1] view] addGestureRecognizer:self.tapRecognizer];
            
            
            
        }
        else{
            // NSLog(@"%@",[self.contentController.childViewControllers objectAtIndex:0]);
            
            //NSLog(@"%@",self.contentController);
            
            [[[self.contentController.childViewControllers objectAtIndex:0] view] removeGestureRecognizer:self.tapRecognizer];

            
        }
        
        
        
        
        
       //[self.containerView removeGestureRecognizer:self.panRecognizer];


    }];
}

#pragma mark State

- (BOOL)isMenuVisible;
{
    return !CGAffineTransformEqualToTransform(self.containerView.transform,
                                              CGAffineTransformIdentity);
}

#pragma mark Statusbar

- (UIView*)statusBarView;
{
    UIView *statusBar = nil;
    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9];
    NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)]) statusBar = [object valueForKey:key];
    return statusBar;
}

@end
