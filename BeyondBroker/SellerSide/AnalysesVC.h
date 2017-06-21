//
//  AnalysesVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 15/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysesVC : UIViewController{
    
    CGSize cellSize;
    float screenWidth;
    
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong,nonatomic)NSMutableArray *arrData;
@end
