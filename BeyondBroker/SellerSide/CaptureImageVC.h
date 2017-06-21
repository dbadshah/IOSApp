//
//  CaptureImageVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 29/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class CIDetector;

@interface CaptureImageVC : UIViewController <UIGestureRecognizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
{
    
    IBOutlet UIView *previewView;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureVideoDataOutput *videoDataOutput;
    
    BOOL detectFaces;
    dispatch_queue_t videoDataOutputQueue;
    AVCaptureStillImageOutput *stillImageOutput;
    
    UIView *flashView;
    UIImage *square;
    
    BOOL isUsingFrontFacingCamera;
    CIDetector *faceDetector;
    
    CGFloat beginGestureScale;
    CGFloat effectiveScale;
    
    NSUInteger sectioncount;
    NSUInteger currentRoomCount;
    
    IBOutlet UIView *readyView;
    IBOutlet UILabel *lbldisplayRoom;
    IBOutlet UILabel *lblRoomName;
    IBOutlet UIButton *btnNext;
    IBOutlet UILabel *lblPhotoTekan;
    IBOutlet UILabel *lblMinimum;
    IBOutlet UILabel *lblMaximum;
    IBOutlet UIButton *btnReviewMyPhotos;
    
    
}

- (IBAction)takePicture:(id)sender;
- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender;
- (IBAction)toggleFaceDetection:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imageview;
@property(strong,nonatomic) NSMutableArray *ArrRoomData;
@property(strong,nonatomic) NSMutableArray *ArrPhotoData;


@end
