//
//  EditProfiteVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface EditProfiteVC : UIViewController{
    
    CGSize cellSize;
    float screenWidth;
    MPMoviePlayerController *moviePlayerController;
    
    
}
@property(strong,nonatomic)NSArray *arrData;
@property(strong,nonatomic)IBOutlet UICollectionView *objCollectionView;
@end
