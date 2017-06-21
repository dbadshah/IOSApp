//
//  ReviewsubmitCell.m
//  BeyondBroker
//
//  Created by Webcore Solution on 14/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ReviewsubmitCell.h"
#import "CollectionSubmissionView.h"

@interface ReviewsubmitCell ()

@property (strong, nonatomic) CollectionSubmissionView *Collection;

@end
@implementation ReviewsubmitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        self.Collection = [[NSBundle mainBundle] loadNibNamed:@"CollectionSubmissionView" owner:self options:nil][0];
        self.Collection.frame = self.bounds;
        [self.contentView addSubview:self.Collection];
        
    }
    return self;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCollectionData:(NSMutableArray *)collectionData {
    [self.Collection setCollectionData:collectionData];
}
@end
