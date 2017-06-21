//
//  PhotoVideoVC.h
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoVideoVC : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *imgView;
    IBOutlet UITextField *txtField;
    UIImage* selectedImage;
    UIActionSheet *actSelectPhotoOption;

    
}

@end
