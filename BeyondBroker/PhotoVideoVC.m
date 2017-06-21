//
//  PhotoVideoVC.m
//  BeyondBroker
//
//  Created by Sarthak Patel on 10/04/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "PhotoVideoVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "WebServiceCall.h"
@interface PhotoVideoVC ()

@end

@implementation PhotoVideoVC

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
    
    txtField.text=[UserDefault valueForKey:@"videoProfileUrl"];
    
}
-(IBAction)goBack:(id)sender{
    
    if (txtField.text.length<1) {
        [Utility showAlertWithTitle:@"Please enter video url." withMessage:nil];
        return;
    }
    if (selectedImage==nil) {
        [Utility showAlertWithTitle:@"Please select profile image" withMessage:nil];
        return;
    }
    
    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:NO_INTERNET_TITLE  withMessage:NO_INTERNET_MSG];
        return;
        
    }
    
    NSData  *imageData = UIImageJPEGRepresentation(selectedImage, 0.4);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    NSString *post = [NSString stringWithFormat: @"agentid=%@&token=%@&save_type=9&agent_profile_image=%@&video_url=%@",CHECK_NULL_STRING([[NSUserDefaults standardUserDefaults] valueForKey:@"loginUserId"]),
                      STATIC_TOKEN,base64,txtField.text];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Agent_Webservice/agent_finish_account"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                
                NSLog(@"%@",dict);
                [self.navigationController popViewControllerAnimated:true];
                
            }else{
                
                [Utility showAlertWithTitle:[dict valueForKey:@"message"] withMessage:nil];
                return;
            }
        }else{
            
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];

    
    
    
    
 //   NSString *filePath = [DOCUMENTPATH stringByAppendingPathComponent:@"ProfileImage.png"];
//    // Save image.
//    [UIImagePNGRepresentation(selectedImage) writeToFile:filePath atomically:YES];
//    
//    [UserDefault setValue:txtField.text forKey:@"videoProfileUrl"];
//    [UserDefault setBool:true forKey:@"PhotoVideo"];
//    [UserDefault synchronize];

    
    
   // [self.navigationController popViewControllerAnimated:true];
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
