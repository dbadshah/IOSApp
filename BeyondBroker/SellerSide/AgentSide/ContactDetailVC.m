//
//  ContactDetailVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 23/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "ContactDetailVC.h"
#import "Utility.h"
#import "ThanksVC.h"
@interface ContactDetailVC ()

@end

@implementation ContactDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    NSString *quickIntro =[UserDefault valueForKey:@"ContactUS"];
    if (quickIntro.length>0) {
        
        txtView.text=quickIntro;
    }
    else{
    
        txtView.placeholder=@"Start typing your question or feedback";
    
    }
    lblCharCount.text=[NSString stringWithFormat:@"%u characters left",300-txtView.text.length];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSInteger totalCharacter;
    totalCharacter=300;
    if ((textView.text.length>300) && (range.length==0)) {
    
        return false;
    
    }
    lblCharCount.text=[NSString stringWithFormat:@"%u characters left",totalCharacter-txtView.text.length];
    return true;
}
-(IBAction)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)saveBtnClick:(id)sender{
    
    if (txtView.text.length<1) {
        [Utility showAlertWithTitle:@"Please enter value" withMessage:nil];
        return;
    }
    
    ThanksVC *objThanksVC =[[ThanksVC alloc] initWithNibName:@"ThanksVC" bundle:nil];
    [self.navigationController pushViewController:objThanksVC animated:true];

}
@end
