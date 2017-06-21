//
//  ServiceProvideVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceProvideVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGSize cellSize;
    float screenWidth;
}
@property(strong,nonatomic)NSMutableArray *arrData;
@property(strong,nonatomic)NSMutableArray *arrSelectedId;
@property(strong,nonatomic)IBOutlet UICollectionView *objCollectionView;
@end
