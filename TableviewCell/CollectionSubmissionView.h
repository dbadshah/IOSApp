//
//  CollectionSubmissionView.h
//  BeyondBroker
//
//  Created by Webcore Solution on 14/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionSubmissionView : UIView
- (void)setCollectionData:(NSMutableArray *)collectionData;

@property (strong, nonatomic) IBOutlet UILabel *lblRoomName;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscription;

@end
