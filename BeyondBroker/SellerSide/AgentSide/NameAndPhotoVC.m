//
//  NameAndPhotoVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "NameAndPhotoVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
@interface NameAndPhotoVC ()

@end

@implementation NameAndPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    imgView.layer.borderWidth=1.0f;
    imgView.layer.borderColor=[UIColor grayColor].CGColor;
    actSelectPhotoOption=[[UIActionSheet alloc] initWithTitle:@"Select image option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Album",@"Take Photo",@"Remove Photo", nil];
    
    NSString *filePath = [DOCUMENTPATH stringByAppendingPathComponent:@"ProfileImage.png"];
    
    selectedImage =[UIImage imageWithContentsOfFile:filePath];
    if (selectedImage!=nil) {
        imgView.image=selectedImage;
    }

    ViewFirst.layer.cornerRadius=2.0f;
    ViewFirst.layer.borderColor=[UIColor grayColor].CGColor;
    ViewFirst.layer.borderWidth=1.0f;
    ViewFirst.layer.masksToBounds=true;
    
    viewLast.layer.cornerRadius=2.0f;
    viewLast.layer.borderColor=[UIColor grayColor].CGColor;
    viewLast.layer.borderWidth=1.0f;
    viewLast.layer.masksToBounds=true;

    
}
-(IBAction)goBack:(id)sender{
    
   if (selectedImage==nil) {
        [Utility showAlertWithTitle:@"Please select profile image" withMessage:nil];
        return;
    }
    NSString *filePath = [DOCUMENTPATH stringByAppendingPathComponent:@"ProfileImage.png"];
    
    // Save image.
    [UIImagePNGRepresentation(selectedImage) writeToFile:filePath atomically:YES];
    [UserDefault setBool:true forKey:@"PhotoVideo"];
    [UserDefault synchronize];
    [self.navigationController popViewControllerAnimated:true];

}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    [self.view endEditing:true];
    
    if(actionSheet==actSelectPhotoOption)
    {
        if (buttonIndex==0) {
            
            [self openAlbum];
        }
        else if(buttonIndex==1)
        {
            [self openCamera];
        }
        else if (buttonIndex==2){
            
            [self removePhoto];
        }
    }
}


-(void)openAlbum{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    //[self presentViewController:imagePickerController animated:YES completion:nil];
    if(iPhone)
    {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else{
        imagePickerController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}
-(void)openCamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
-(void)removePhoto{

    selectedImage=nil;
    imgView.image=[UIImage imageNamed:@"AddProfilePic.png"];

}
-(IBAction)showImageSelectOption{
    
    [self.view endEditing:true];
    [actSelectPhotoOption showInView:self.view];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    // imageView.image = image;
    // [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:true completion:^{
        
        imgView.image=selectedImage;
    }];
}
@end
