//
//  YourHomeVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 18/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "YourHomeVC.h"
#import "Utility.h"
#import <GoogleMaps/GoogleMaps.h>
#import "WebServiceCall.h"
#import "XMLReader.h"
#import "SellingReasonVC.h"
#import "RoomDetail.h"
#import "DataManager.h"

@interface YourHomeVC ()<GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong,nonatomic) NSMutableData *webResponseData;

@end

@implementation YourHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationCoordinate2D cla = [self getLocationFromAddressString:self.Address];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = cla;
    self.mapView.delegate = self;
    marker.map = self.mapView;
    
    self.mapView.layer.cornerRadius=2.0f;
    self.mapView.layer.borderColor=[UIColor grayColor].CGColor;
    self.mapView.layer.borderWidth=1.0f;
    self.mapView.layer.masksToBounds=true;
    [self GetGeocodeData];

}
-(void)viewWillAppear:(BOOL)animated{

    if ([UserDefault boolForKey:IS_EDIT]==YES) {
        
     btnBack.hidden=YES;
        
        
        NSString *address=[UserDefault valueForKey:ADDRESS];
        
        CLLocationCoordinate2D cla = [self getLocationFromAddressString:CHECK_NULL_STRING(address)];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = cla;
        self.mapView.delegate = self;
        marker.map = self.mapView;
        
        self.mapView.layer.cornerRadius=2.0f;
        self.mapView.layer.borderColor=[UIColor grayColor].CGColor;
        self.mapView.layer.borderWidth=1.0f;
        self.mapView.layer.masksToBounds=true;
        
        
        NSString *bed=[UserDefault valueForKey:HOME_BED];
        NSString *bath=[UserDefault valueForKey:HOME_BATH];
        NSString *sqft=[UserDefault valueForKey:SQFT];
        NSString *yearbuilt=[UserDefault valueForKey:YEAR_BUILT];
        
        lblBaths.text=CHECK_NULL_STRING(bed);
        lblBeads.text=CHECK_NULL_STRING(bath);
        lblSqft.text=CHECK_NULL_STRING(sqft);
        lblYearBuilt.text=CHECK_NULL_STRING(yearbuilt);
        
    
    
    }else{
        
         btnBack.hidden=NO;
    }

    [super viewWillAppear:animated];

}
double latitude = 0, longitude = 0;
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
   
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
      
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"Logitute : %f",center.latitude);
    NSLog(@"Latitute : %f",center.longitude);
   
    self.mapView.camera  = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:17.f];
    
    return center;

}

-(void)GetGeocodeData{
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(latitude, longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:");
        for(GMSAddress* addressObj in [response results])
        {
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
            
            NSString *Street_address=[NSString stringWithFormat:@"%@",addressObj.thoroughfare];
            NSString *City=[NSString stringWithFormat:@"%@",addressObj.locality];
            NSString *State=[NSString stringWithFormat:@"%@",addressObj.administrativeArea];
            NSString *Zip_code=[NSString stringWithFormat:@"%@",addressObj.postalCode];
          //  NSString *Country=[NSString stringWithFormat:@"%@",addressObj.country];

            
            [UserDefault setObject:Street_address forKey:ADDRESS];
            [UserDefault setObject:City forKey:CITY];
            [UserDefault setObject:State forKey:STATE];
            [UserDefault setObject:Zip_code forKey:ZIPCODE];
            
            NSString *citystatezip=[NSString stringWithFormat:@"%@+%@+%@",City,State,Zip_code];
            NSString *Url=[NSString stringWithFormat:@"http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz199vp77f763_6zfs6&address=%@&citystatezip=%@",Street_address,citystatezip];
            
            NSString *URL = [Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self GetlistingData:URL];
            
            break;
        
        }
    }];
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)btnMyHomeClick:(id)sender {

    [DATA_MANAGER DeletePhotoDetail];
    [DATA_MANAGER DeleteRoomDetail];
    
    for (int i = 0; i < 1; i++)
    {
        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
        objRoomDetail.room_id=@"1001";
        objRoomDetail.room_name=@"Kitchen";
        objRoomDetail.room_type=@"Kitchen";
        objRoomDetail.room_details=@"";
        objRoomDetail.photos_limit=@"2";
        [DATA_MANAGER insertRoom:objRoomDetail];
    
    }
    
    NSInteger bed=[lblBeads.text integerValue];
    for (int i = 0; i < bed; i++)
    {
        int count =  1 +  i;
        int roomid = 2001 + i;
        
        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
        objRoomDetail.room_name=[NSString stringWithFormat:@"Bedroom %d",count];
        objRoomDetail.room_type=@"Bedroom";
        objRoomDetail.room_details=@"";
        objRoomDetail.photos_limit=@"1";
        [DATA_MANAGER insertRoom:objRoomDetail];

    }
   
    NSInteger bath =[lblBaths.text integerValue];
    for (int i = 0; i < bath; i++)
    {
        int count =  1 +  i;
        int roomid = 3001 + i;
        
        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
        objRoomDetail.room_name=[NSString stringWithFormat:@"Bathroom %d",count];
        objRoomDetail.room_type=@"Bathroom";
        objRoomDetail.room_details=@"";
        objRoomDetail.photos_limit=@"1";
        [DATA_MANAGER insertRoom:objRoomDetail];

    }
    
    for (int i = 0; i < 1; i++)
    {
        int roomid = 4001 + i;
        
        RoomDetail *objRoomDetail=[[RoomDetail alloc]init];
        objRoomDetail.room_id=[NSString stringWithFormat:@"%d",roomid];
        objRoomDetail.room_name=[NSString stringWithFormat:@"Other"];
        objRoomDetail.room_type=@"Other";
        objRoomDetail.room_details=@"";
        objRoomDetail.photos_limit=@"0";
        [DATA_MANAGER insertRoom:objRoomDetail];

    }

    
    [self SubmitSetup1];
    

}
-(void)GetlistingData:(NSString *)Url{
    
    
    [self.view endEditing:true];
    
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:@"No Internet!"  withMessage:@"You are not connected to internet, check your internet connection!"];
        return;
    }
    
//     NSString *url=@"http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz199vp77f763_6zfs6&address=4355+242ND&citystatezip=PL+SE+98029";
    
    [[WebServiceCall getInstance] sendRequestWithUrl:Url withData:nil withMehtod:@"GET" withLoadingAlert:@"" withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
     
        NSString *theXML = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSDictionary *dictResponce = [XMLReader dictionaryForXMLString:theXML error:&error];
        NSLog(@"Dictionary = %@",dictResponce);

        if (success) {
            
            NSString *bathrooms=[NSString stringWithFormat:@"%@",[[[[[[dictResponce  objectForKey:@"SearchResults:searchresults"] objectForKey:@"response"] objectForKey:@"results"] objectForKey:@"result"] objectForKey:@"bathrooms"] objectForKey:@"text"]];
            
           
            if (bathrooms == nil || bathrooms == (id)[NSNull null] || [bathrooms isEqualToString:@"(null)"]) {
               
                NSLog(@"null");
                [UserDefault setObject:@"0" forKey:HOME_BATH];
                
            }else{
              
                lblBaths.text= [NSString stringWithFormat:@"%@",CHECK_NULL_STRING(bathrooms)];
           
                [UserDefault setObject:bathrooms forKey:HOME_BATH];
            }
            
            NSString *bedrooms=[NSString stringWithFormat:@"%@",[[[[[[dictResponce  objectForKey:@"SearchResults:searchresults"] objectForKey:@"response"] objectForKey:@"results"] objectForKey:@"result"] objectForKey:@"bedrooms"]objectForKey:@"text"]];
            
            
            if (bedrooms == nil || bedrooms == (id)[NSNull null] || [bedrooms isEqualToString:@"(null)"]) {
                
                  [UserDefault setObject:@"0" forKey:HOME_BED];
                
            }else{
                
                  lblBeads.text=[NSString stringWithFormat:@"%@",CHECK_NULL_STRING(bedrooms)];
                  [UserDefault setObject:bedrooms forKey:HOME_BED];
            }
            
           NSString *finishedSqFt=[NSString stringWithFormat:@"%@",[[[[[[dictResponce  objectForKey:@"SearchResults:searchresults"] objectForKey:@"response"] objectForKey:@"results"] objectForKey:@"result"] objectForKey:@"finishedSqFt"]objectForKey:@"text"]];
            
           if (finishedSqFt == nil || finishedSqFt == (id)[NSNull null] || [finishedSqFt isEqualToString:@"(null)"]) {
                
               [UserDefault setObject:@"0" forKey:SQFT];
                
            }else{
                
                lblSqft.text=[NSString stringWithFormat:@"%@",CHECK_NULL_STRING(finishedSqFt)];
                 [UserDefault setObject:finishedSqFt forKey:SQFT];
            }
            
            
            NSString *yearBuilt=[NSString stringWithFormat:@"%@",[[[[[[dictResponce  objectForKey:@"SearchResults:searchresults"] objectForKey:@"response"] objectForKey:@"results"] objectForKey:@"result"] objectForKey:@"yearBuilt"]objectForKey:@"text"]];
            
            if (yearBuilt == nil || yearBuilt == (id)[NSNull null] || [yearBuilt isEqualToString:@"(null)"]) {
                
                [UserDefault setObject:@"0" forKey:YEAR_BUILT];
         
            }else{
                
                lblYearBuilt.text=[NSString stringWithFormat:@"%@",CHECK_NULL_STRING(yearBuilt)];
                [UserDefault setObject:yearBuilt forKey:YEAR_BUILT];
            
            }
           
            NSString *zpid=[NSString stringWithFormat:@"%@",[[[[[[dictResponce  objectForKey:@"SearchResults:searchresults"] objectForKey:@"response"] objectForKey:@"results"] objectForKey:@"result"] objectForKey:@"zpid"]objectForKey:@"text"]];
            
            if (zpid == nil || zpid == (id)[NSNull null] || [zpid isEqualToString:@"(null)"]) {
                
                [UserDefault setObject:@"0" forKey:HOME_ID];
                
            }else{
                
                [UserDefault setObject:zpid forKey:HOME_ID];
                
            }
            NSString *useCode=[NSString stringWithFormat:@"%@",[[[[[[dictResponce  objectForKey:@"SearchResults:searchresults"] objectForKey:@"response"] objectForKey:@"results"] objectForKey:@"result"] objectForKey:@"useCode"]objectForKey:@"text"]];
            
            if (useCode == nil || useCode == (id)[NSNull null] || [useCode isEqualToString:@"(null)"]) {
                
                [UserDefault setObject:@"0" forKey:USECODE];
                
            }else{
                
                [UserDefault setObject:useCode forKey:USECODE];
                
            }
        }
        else{
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
    
}
-(void)SubmitSetup1{
    
    [self.view endEditing:true];
    if (![Utility isInternetConnected]) {
        
        [Utility showAlertWithTitle:@"No Internet!"  withMessage:@"You are not connected to internet, check your internet connection!"];
        return;
    }
 
    NSString *UserId=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:@"loginUserId"]];
    NSString *home_id=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_ID]];
    NSString *City=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:CITY]];
    NSString *State=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:STATE]];
    NSString *Zip_code=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:ZIPCODE]];
    NSString *home_type=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:USECODE]];
    NSString *bedrooms=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_BED]];
    NSString *bathrooms=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:HOME_BATH]];
    NSString *finishedSqFt=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:SQFT]];
    NSString *yearBuilt=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:YEAR_BUILT]];
    NSString *search_home_address=[NSString stringWithFormat:@"%@",[UserDefault valueForKey:ADDRESS]];
    
    NSString *post = [NSString stringWithFormat:@"token=%@&step_id=1&user_id=%@&home_id=%@&city=%@&state=%@&zipcode=%@&home_type=%@&search_home_address=%@&bathrooms=%@&bedrooms=%@&finishedSqFt=%@&yearBuilt=%@",@"1920573288",UserId,home_id,City,State,Zip_code,home_type,search_home_address,bathrooms,bedrooms,finishedSqFt,yearBuilt];
  
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [[WebServiceCall getInstance] sendRequestWithUrl:[MAIN_URL stringByAppendingPathComponent:@"Seller_Webservice/seller_property_save"] withData:postData withMehtod:@"POST" withLoadingAlert:@"Loading.." withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if (success) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            self.arrData=[[NSMutableArray alloc]init];
            
            if([[dict valueForKey:@"status"] integerValue]==1)
            {
                SellingReasonVC *objYourVC =[[SellingReasonVC alloc] initWithNibName:@"SellingReasonVC" bundle:nil];
                [self.navigationController pushViewController:objYourVC animated:true];
                
            }else{
                
                [Utility showAlertWithTitle:nil withMessage:CHECK_NULL_STRING([dict valueForKey:@"message"])];
                return;
            }
        
        }else{
         
            [Utility showAlertWithTitle:nil withMessage:[error localizedDescription]];
            return;
        }
        
    }];
    
}
@end
