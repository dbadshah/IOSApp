//
//  NameAndPhotoVC.h
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameAndPhotoVC : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *imgView;
    UIImage* selectedImage;
    UIActionSheet *actSelectPhotoOption;
 
    IBOutlet UIView *ViewFirst;
    IBOutlet UIView *viewLast;
  
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    
    
}


@end
