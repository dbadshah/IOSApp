//
//  CaptureImageVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 29/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "CaptureImageVC.h"
@import AVFoundation;
@import Photos;
#import <UIKit/UIKit.h>
#import "PhotoExmpleVC.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Utility.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "PhotoDetail.h"
#import "ReviewPhotoVC.h"
#import "RoomDetailVC.h"

static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";
static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
static void ReleaseCVPixelBuffer(void *pixel, const void *data, size_t size);
static void ReleaseCVPixelBuffer(void *pixel, const void *data, size_t size)
{
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)pixel;
    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
    CVPixelBufferRelease( pixelBuffer );
}

static OSStatus CreateCGImageFromCVPixelBuffer(CVPixelBufferRef pixelBuffer, CGImageRef *imageOut);
static OSStatus CreateCGImageFromCVPixelBuffer(CVPixelBufferRef pixelBuffer, CGImageRef *imageOut)
{
    OSStatus err = noErr;
    OSType sourcePixelFormat;
    size_t width, height, sourceRowBytes;
    void *sourceBaseAddr = NULL;
    CGBitmapInfo bitmapInfo;
    CGColorSpaceRef colorspace = NULL;
    CGDataProviderRef provider = NULL;
    CGImageRef image = NULL;
    
    sourcePixelFormat = CVPixelBufferGetPixelFormatType( pixelBuffer );
    if ( kCVPixelFormatType_32ARGB == sourcePixelFormat )
        bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipFirst;
    else if ( kCVPixelFormatType_32BGRA == sourcePixelFormat )
        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    else
        return -95014; // only uncompressed pixel formats
    
    sourceRowBytes = CVPixelBufferGetBytesPerRow( pixelBuffer );
    width = CVPixelBufferGetWidth( pixelBuffer );
    height = CVPixelBufferGetHeight( pixelBuffer );
    
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    sourceBaseAddr = CVPixelBufferGetBaseAddress( pixelBuffer );
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    CVPixelBufferRetain( pixelBuffer );
    provider = CGDataProviderCreateWithData( (void *)pixelBuffer, sourceBaseAddr, sourceRowBytes * height, ReleaseCVPixelBuffer);
    image = CGImageCreate(width, height, 8, 32, sourceRowBytes, colorspace, bitmapInfo, provider, NULL, true, kCGRenderingIntentDefault);
    
bail:
    if ( err && image ) {
        CGImageRelease( image );
        image = NULL;
    }
    if ( provider ) CGDataProviderRelease( provider );
    if ( colorspace ) CGColorSpaceRelease( colorspace );
    *imageOut = image;
    return err;
}

// utility used by newSquareOverlayedImageForFeatures for
static CGContextRef CreateCGBitmapContextForSize(CGSize size);
static CGContextRef CreateCGBitmapContextForSize(CGSize size)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow = (size.width * 4);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate (NULL,
                                     size.width,
                                     size.height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    CGContextSetAllowsAntialiasing(context, NO);
    CGColorSpaceRelease( colorSpace );
    return context;
}

#pragma mark-

@interface UIImage (RotationMethods)
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end

@implementation UIImage (RotationMethods)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end

#pragma mark-

@interface CaptureImageVC (InternalMethods)
- (void)setupAVCapture;
- (void)teardownAVCapture;
- (void)drawFaceBoxesForFeatures:(NSArray *)features forVideoBox:(CGRect)clap orientation:(UIDeviceOrientation)orientation;
@end


@interface CaptureImageVC ()

@end

RoomDetail *ObjRoomDetail;
@implementation CaptureImageVC

- (void)setupAVCapture
{
    NSError *error = nil;
    
    AVCaptureSession *session = [AVCaptureSession new];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
       [session setSessionPreset:AVCaptureSessionPresetInputPriority];
    
    else
    
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    // Select a video device, make an input
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    isUsingFrontFacingCamera = NO;
    if ([session canAddInput:deviceInput])
      
        [session addInput:deviceInput];
    
    // Make a still image output
    stillImageOutput = [AVCaptureStillImageOutput new];
    [stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(AVCaptureStillImageIsCapturingStillImageContext)];
    if ( [session canAddOutput:stillImageOutput] )
        [session addOutput:stillImageOutput];
    
    // Make a video data output
    videoDataOutput = [AVCaptureVideoDataOutput new];
    
    // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
    
   
    videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ( [session canAddOutput:videoDataOutput] )
        [session addOutput:videoDataOutput];
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
    
    effectiveScale = 1.0;
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [previewView layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:previewLayer];
    [session startRunning];
    
    bail:
       if (error) {
        
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]] message:[error localizedDescription] delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
        [self teardownAVCapture];
    }
}

// clean up capture setup
- (void)teardownAVCapture
{
    
    if (videoDataOutputQueue)
    [stillImageOutput removeObserver:self forKeyPath:@"isCapturingStillImage"];
    [previewLayer removeFromSuperlayer];
   
}

// perform a flash bulb animation using KVO to monitor the value of the capturingStillImage property of the AVCaptureStillImageOutput class
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == (__bridge void * _Nullable)(AVCaptureStillImageIsCapturingStillImageContext) ) {
        BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        if ( isCapturingStillImage ) {
            // do flash bulb like animation
            flashView = [[UIView alloc] initWithFrame:[previewView frame]];
            [flashView setBackgroundColor:[UIColor whiteColor]];
            [flashView setAlpha:0.f];
            [[[self view] window] addSubview:flashView];
            
            [UIView animateWithDuration:.4f
                             animations:^{
                                 [flashView setAlpha:1.f];
                             }
             ];
        }
        else {
            [UIView animateWithDuration:.4f
                             animations:^{
                                 [flashView setAlpha:0.f];
                             }
                             completion:^(BOOL finished){
                                 [flashView removeFromSuperview];
                                 flashView = nil;
                             }
             ];
        }
    }
}

// utility routing used during image capture to set up capture orientation
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
    
        result = AVCaptureVideoOrientationLandscapeRight;
   
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
    
        result = AVCaptureVideoOrientationLandscapeLeft;
    
    return result;
}

// utility routine to create a new image with the red square overlay with appropriate orientation
// and return the new composited image which can be saved to the camera roll
- (CGImageRef)newSquareOverlayedImageForFeatures:(NSArray *)features
                                       inCGImage:(CGImageRef)backgroundImage
                                 withOrientation:(UIDeviceOrientation)orientation
                                     frontFacing:(BOOL)isFrontFacing
{
    CGImageRef returnImage = NULL;
    CGRect backgroundImageRect = CGRectMake(0., 0., CGImageGetWidth(backgroundImage), CGImageGetHeight(backgroundImage));
    CGContextRef bitmapContext = CreateCGBitmapContextForSize(backgroundImageRect.size);
    CGContextClearRect(bitmapContext, backgroundImageRect);
    CGContextDrawImage(bitmapContext, backgroundImageRect, backgroundImage);
    CGFloat rotationDegrees = 0.;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            rotationDegrees = -90.;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotationDegrees = 90.;
            break;
        case UIDeviceOrientationLandscapeLeft:
            if (isFrontFacing) rotationDegrees = 180.;
            else rotationDegrees = 0.;
            break;
        case UIDeviceOrientationLandscapeRight:
            if (isFrontFacing) rotationDegrees = 0.;
            else rotationDegrees = 180.;
            break;
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        default:
            break; // leave the layer in its last known orientation
    }
    
    UIImage *rotatedSquareImage = [square imageRotatedByDegrees:rotationDegrees];
    self.imageview.image=rotatedSquareImage;
    
    
    // features found by the face detector
    for ( CIFaceFeature *ff in features ) {
        CGRect faceRect = [ff bounds];
        CGContextDrawImage(bitmapContext, faceRect, [rotatedSquareImage CGImage]);
    }
    returnImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease (bitmapContext);
    
    return returnImage;
}

// utility routine used after taking a still image to write the resulting image to the camera roll
- (BOOL)writeCGImageToCameraRoll:(CGImageRef)cgImage withMetadata:(NSDictionary *)metadata
{
    CFMutableDataRef destinationData = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(destinationData,
                                                                         CFSTR("public.jpeg"),
                                                                         1,
                                                                         NULL);
    BOOL success = (destination != NULL);
    
    const float JPEGCompQuality = 0.85f; // JPEGHigherQuality
    CFMutableDictionaryRef optionsDict = NULL;
    CFNumberRef qualityNum = NULL;
    
    qualityNum = CFNumberCreate(0, kCFNumberFloatType, &JPEGCompQuality);
    if ( qualityNum ) {
        optionsDict = CFDictionaryCreateMutable(0, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        if ( optionsDict )
            CFDictionarySetValue(optionsDict, kCGImageDestinationLossyCompressionQuality, qualityNum);
        CFRelease( qualityNum );
    }
    
    CGImageDestinationAddImage( destination, cgImage, optionsDict );
    success = CGImageDestinationFinalize( destination );
    
    if ( optionsDict )
        CFRelease(optionsDict);
    
    
    CFRetain(destinationData);
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library writeImageDataToSavedPhotosAlbum:(__bridge id)destinationData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (destinationData)
            CFRelease(destinationData);
    }];
  
    
    
bail:
    if (destinationData)
        CFRelease(destinationData);
    if (destination)
        CFRelease(destination);
    return success;
}

// utility routine to display error aleart if takePicture fails
- (void)displayErrorOnMainQueue:(NSError *)error withMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%d)", message, (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    });
}

// main action method to take a still image -- if face detection has been turned on and a face has been detected
// the square overlay will be composited on top of the captured image and saved to the camera roll
- (IBAction)takePicture:(id)sender
{
   
    // Find out the current orientation and tell the still image output.
    AVCaptureConnection *stillImageConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:effectiveScale];
    
    BOOL doingFaceDetection = detectFaces && (effectiveScale == 1.0);
    if (doingFaceDetection)
    
        [stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                                                        forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    else
        [stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG
                                                                        forKey:AVVideoCodecKey]];
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
    completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
    if (error) {
        [self displayErrorOnMainQueue:error withMessage:@"Take picture failed"];
        }else {
            if (doingFaceDetection) {
                                                              // Got an image.
                CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(imageDataSampleBuffer);
                CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
                    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
                        if (attachments)
                            CFRelease(attachments);
                            NSDictionary *imageOptions = nil;
                            NSNumber *orientation = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyOrientation, NULL);
                            if (orientation) {
                                imageOptions = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
                            }
                            dispatch_sync(videoDataOutputQueue, ^(void) {
                                                                  
                            // get the array of CIFeature instances in the given image with a orientation passed in
                            // the detection will be done based on the orientation but the coordinates in the returned features will
                            // still be based on those of the image.
                            NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
                            CGImageRef srcImage = NULL;
                            OSStatus err = CreateCGImageFromCVPixelBuffer(CMSampleBufferGetImageBuffer(imageDataSampleBuffer), &srcImage);
                            check(!err);
                                                                  
                            CGImageRef cgImageResult = [self newSquareOverlayedImageForFeatures:features
                            inCGImage:srcImage withOrientation:curDeviceOrientation frontFacing:isUsingFrontFacingCamera];
                           
                            if (srcImage)
                            
                                CFRelease(srcImage);
                                CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                imageDataSampleBuffer,kCMAttachmentMode_ShouldPropagate);
                           
                                [self writeCGImageToCameraRoll:cgImageResult withMetadata:(__bridge id)attachments];
                            
                            if (attachments)
                                
                                CFRelease(attachments);
                           
                            if (cgImageResult)
                            
                                CFRelease(cgImageResult);
                                                                  
                            });
                                                              
                                                            
            }else {
            
        //trivial simple JPEG case
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
        imageDataSampleBuffer,kCMAttachmentMode_ShouldPropagate);
           
        ObjRoomDetail.TakenPhotos++;
        
        UIImage *image = [[UIImage alloc] initWithData:jpegData];
        self.imageview.image=image;
        
        [self StoreImageinDB:image];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
                    
             [self displayErrorOnMainQueue:error withMessage:@"Save to camera roll failed"];
                                    
            }
            }];
            if (attachments)
                     
                CFRelease(attachments);
    
             }
           }
        }
     ];
}

// turn on/off face detection
- (IBAction)toggleFaceDetection:(id)sender
{
    detectFaces = [(UISwitch *)sender isOn];
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:detectFaces];
    if (!detectFaces) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            // clear out any squares currently displaying.
        
            [self drawFaceBoxesForFeatures:[NSArray array] forVideoBox:CGRectZero orientation:UIDeviceOrientationPortrait];
        
        });
    }
}

// find where the video box is positioned within the preview layer based on the video size and gravity

+ (CGRect)videoPreviewBoxForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize
{
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    
    CGSize size = CGSizeZero;
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        if (viewRatio > apertureRatio) {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        } else {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        }
    
        
        } else if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        if (viewRatio > apertureRatio) {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        } else {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResize]) {
        size.width = frameSize.width;
        size.height = frameSize.height;
    }

    CGRect videoBox;
    videoBox.size = size;
    if (size.width < frameSize.width)
        videoBox.origin.x = (frameSize.width - size.width) / 2;
    else
        videoBox.origin.x = (size.width - frameSize.width) / 2;
    
    if ( size.height < frameSize.height )
        videoBox.origin.y = (frameSize.height - size.height) / 2;
    else
        videoBox.origin.y = (size.height - frameSize.height) / 2;
    
    return videoBox;
}
- (void)drawFaceBoxesForFeatures:(NSArray *)features forVideoBox:(CGRect)clap orientation:(UIDeviceOrientation)orientation
{
    NSArray *sublayers = [NSArray arrayWithArray:[previewLayer sublayers]];
    NSInteger sublayersCount = [sublayers count], currentSublayer = 0;
    NSInteger featuresCount = [features count], currentFeature = 0;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    // hide all the face layers
    for ( CALayer *layer in sublayers ) {
        if ( [[layer name] isEqualToString:@"FaceLayer"] )
            [layer setHidden:YES];
    }
    
    if ( featuresCount == 0 || !detectFaces ) {
        [CATransaction commit];
        return; // early bail.
    }
    
    CGSize parentFrameSize = [previewView frame].size;
    NSString *gravity = [previewLayer videoGravity];
    BOOL isMirrored = [previewLayer isMirrored];
    
    CGRect previewBox = [CaptureImageVC videoPreviewBoxForGravity:gravity frameSize:parentFrameSize apertureSize:clap.size];
    
    for ( CIFaceFeature *ff in features ) {
         CGRect faceRect = [ff bounds];
        
        // flip preview width and height
        CGFloat temp = faceRect.size.width;
        faceRect.size.width = faceRect.size.height;
        faceRect.size.height = temp;
        temp = faceRect.origin.x;
        faceRect.origin.x = faceRect.origin.y;
        faceRect.origin.y = temp;
        // scale coordinates so they fit in the preview box, which may be scaled
        CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
        CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
        faceRect.size.width *= widthScaleBy;
        faceRect.size.height *= heightScaleBy;
        faceRect.origin.x *= widthScaleBy;
        faceRect.origin.y *= heightScaleBy;
        
        if (isMirrored)
            faceRect = CGRectOffset(faceRect, previewBox.origin.x + previewBox.size.width - faceRect.size.width - (faceRect.origin.x * 2), previewBox.origin.y);
        else
            
            faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y);
        
         CALayer *featureLayer = nil;
        
        // re-use an existing layer if possible
        while ( !featureLayer && (currentSublayer < sublayersCount) ) {
            CALayer *currentLayer = [sublayers objectAtIndex:currentSublayer++];
            if ( [[currentLayer name] isEqualToString:@"FaceLayer"] ) {
                featureLayer = currentLayer;
                [currentLayer setHidden:NO];
            }
        }
        
        // create a new one if necessary
        if ( !featureLayer ) {
            featureLayer = [CALayer new];
            [featureLayer setContents:(id)[square CGImage]];
            [featureLayer setName:@"FaceLayer"];
            [previewLayer addSublayer:featureLayer];
          
        }
        [featureLayer setFrame:faceRect];
        
        switch (orientation) {
            case UIDeviceOrientationPortrait:
                [featureLayer setAffineTransform:CGAffineTransformMakeRotation(DegreesToRadians(0.))];
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                [featureLayer setAffineTransform:CGAffineTransformMakeRotation(DegreesToRadians(180.))];
                break;
            case UIDeviceOrientationLandscapeLeft:
                [featureLayer setAffineTransform:CGAffineTransformMakeRotation(DegreesToRadians(90.))];
                break;
            case UIDeviceOrientationLandscapeRight:
                [featureLayer setAffineTransform:CGAffineTransformMakeRotation(DegreesToRadians(-90.))];
                break;
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationFaceDown:
            default:
                break; // leave the layer in its last known orientation
        }
        currentFeature++;
    }
    
    [CATransaction commit];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{	
    // got an image
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    if (attachments)
        CFRelease(attachments);
    NSDictionary *imageOptions = nil;
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    int exifOrientation;
    enum {
        PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
        PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.  
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.  
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.  
        PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.  
        PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.  
        PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.  
        PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.  
    };
    
    switch (curDeviceOrientation) {
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
           
            exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
           
            break;
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            break;
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        default:
            exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
            break;
    }
    
    imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exifOrientation] forKey:CIDetectorImageOrientation];
    NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
    
    // get the clean aperture
    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    // that represents image data valid for display.
    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self drawFaceBoxesForFeatures:features forVideoBox:clap orientation:curDeviceOrientation];
    });
}

- (void)dealloc
{
    [self teardownAVCapture];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    [self setupAVCapture];
    square = [UIImage imageNamed:@"squarePNG"];
    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
    faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    sectioncount=0;
    currentRoomCount=0;
    
    btnNext.hidden=YES;
    [self getRoomDetail];
    
}
-(void)StoreImageinDB:(UIImage *)Captureimg{
    
    NSInteger intLimit = [ObjRoomDetail.photos_limit integerValue];
    
    NSData  *imageData = UIImageJPEGRepresentation(Captureimg, 0.4);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    PhotoDetail *ObjphotoDetail=[[PhotoDetail alloc]init];
    ObjphotoDetail.room_id=ObjRoomDetail.room_id;
    ObjphotoDetail.room_image=base64;
    [DATA_MANAGER insertphoto:ObjphotoDetail];
   
    lblPhotoTekan.text=[NSString stringWithFormat:@"Photos Taken:%ld",(long)ObjRoomDetail.TakenPhotos];
   
    
    if (ObjRoomDetail.TakenPhotos < 5) {
        
        if (intLimit > ObjRoomDetail.TakenPhotos) {
            
            NSLog(@"No Limit complete");
            
        }else{
            
            NSString *roomtype=[NSString stringWithFormat:@"%@",ObjRoomDetail.room_type];
            
            if ([roomtype isEqualToString:@"Other"]) {
                
                 btnNext.hidden = YES;
            
            }else{
               
                NSLog(@"You can skip now");
                btnNext.hidden = NO;
                
            }
        }
        
    }else{
        
        sectioncount++;
        [self getRoomDetail];
    }
   
}
-(void)getRoomDetail{
    
    self.ArrRoomData=[DATA_MANAGER getRoomList];
  
    if (self.ArrRoomData.count==0) {
        
   
   
    }else{
        
      if (self.ArrRoomData.count == sectioncount) {
            
           NSLog(@"No more data");
          
      
      }else{
          
            readyView.hidden=NO;
            btnNext.hidden=YES;
          
            ObjRoomDetail=[self.ArrRoomData objectAtIndex:sectioncount];
            lblRoomName.text=[NSString stringWithFormat:@"Room: %@",ObjRoomDetail.room_name];
            NSString *roomtype=[NSString stringWithFormat:@"%@",ObjRoomDetail.room_type];
          
            lblMaximum.text=[NSString stringWithFormat:@"Maximum:5"];
            lblPhotoTekan.text=@"Photos Taken:0";
            lblMinimum.text= [NSString stringWithFormat:@"Minimum:%ld",(long)[ObjRoomDetail.photos_limit integerValue]];
            btnReviewMyPhotos.hidden=YES;
          
          if ([roomtype isEqualToString:@"Kitchen"]) {
              
              lbldisplayRoom.text=@"We'll Start in the kitchen";
              
          }else if ([roomtype isEqualToString:@"Other"]){
              
              btnNext.hidden=YES;
              btnReviewMyPhotos.hidden=NO;
              lbldisplayRoom.text=[NSString stringWithFormat:@"Next room: %@",ObjRoomDetail.room_name];
          
          }else{
              
             lbldisplayRoom.text=[NSString stringWithFormat:@"Next room: %@",ObjRoomDetail.room_name];
        
          }
          
      }
        
   }
}
-(IBAction)btnReviewPhotoClick:(id)sender{

    NSLog(@"Review photos Click");
    ReviewPhotoVC *objReviewPhotoVC =[[ReviewPhotoVC alloc] initWithNibName:@"ReviewPhotoVC" bundle:nil];
    [self.navigationController pushViewController:objReviewPhotoVC animated:true];
    
}
- (IBAction)btnRoomDescription:(id)sender{
    
    RoomDetailVC *objRoomDetailVC =[[RoomDetailVC alloc] initWithNibName:@"RoomDetailVC" bundle:nil];
    objRoomDetailVC.room_id=ObjRoomDetail.room_id;
    [self.navigationController pushViewController:objRoomDetailVC animated:true];

}
-(IBAction)btnReadyClick:(id)sender {
    
    readyView.hidden=YES;

}
-(IBAction)btnNextRoomClick:(id)sender {
    
    ObjRoomDetail.TakenPhotos = 0;
    sectioncount++;
    [self getRoomDetail];
    
}
-(IBAction)btnExmpleClick:(id)sender {
    
    PhotoExmpleVC *objPhotoExmpleVC =[[PhotoExmpleVC alloc] initWithNibName:@"PhotoExmpleVC" bundle:nil];
    [self.navigationController pushViewController:objPhotoExmpleVC animated:true];

}
@end
