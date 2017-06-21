//
//  RoomDetailVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 16/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "RoomDetailVC.h"
#import "Utility.h"
#import "DataManager.h"
@interface RoomDetailVC ()

@end

@implementation RoomDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    NSString *quickIntro =[DATA_MANAGER getRoomDescription:self.room_id];
    
    NSLog(@"%@",self.room_id);
    
    if (quickIntro.length>0) {
        
        txtView.text=quickIntro;
    
    }else{
        
        txtView.placeholder=@"Enter room description.";
    }
}
-(IBAction)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)saveBtnClick:(id)sender{
    
    if (txtView.text.length<1) {
        [Utility showAlertWithTitle:@"Please enter room description." withMessage:nil];
        return;
    }
    
    [DATA_MANAGER UpdateRoomDescription:self.room_id roomdescription:txtView.text];
    [self.navigationController popViewControllerAnimated:true];
    
}
@end
