//
//  HomeSpecializationVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 08/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSpecializationVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGSize cellSize;
    float screenWidth;
}

@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *arrSelectedId;
@property(strong,nonatomic)IBOutlet UICollectionView *objCollectionView;
@end
