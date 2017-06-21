//
//  SelectAddressVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 18/05/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "SelectAddressVC.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <MapKit/MapKit.h>
#import "CLPlacemark+HNKAdditions.h"
#import "AddressCell.h"
#import "YourHomeVC.h"
#import "Utility.h"
static NSString *const kHNKDemoSearchResultsCellIdentifier = @"HNKDemoSearchResultsCellIdentifier";

@interface SelectAddressVC () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation SelectAddressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];

    self.textview.layer.cornerRadius=2.0f;
    self.textview.layer.borderColor=[UIColor grayColor].CGColor;
    self.textview.layer.borderWidth=1.0f;
    self.textview.layer.masksToBounds=true;
   
    [self registerNibForCustomCell];

}

-(void)registerNibForCustomCell{
    
    UINib *nibListingCell=[UINib nibWithNibName:@"AddressCell" bundle:nil];
    [self.tableView registerNib:nibListingCell forCellReuseIdentifier:@"AddressCell"];
    
}
#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *Cell =  [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    HNKGooglePlacesAutocompletePlace *thisPlace = self.searchResults[indexPath.row];
    Cell.lblTitle.text = thisPlace.name;
    return Cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.txtAddress resignFirstResponder];
    
    HNKGooglePlacesAutocompletePlace *selectedPlace = self.searchResults[indexPath.row];
    [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                       apiKey: self.searchQuery.apiKey
                                   completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                       if (placemark) {
                                           [self.tableView setHidden: YES];
                                           self.txtAddress.text=addressString;
                                           //[self getLocationFromAddressString:addressString];
                                           [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                                       }
                                   }];


}

#pragma mark - UISearchBar Delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *String =textField.text;
    if (textField == self.txtAddress) {
        
        if (String.length > 0) {
            [self.tableView setHidden:NO];
            [self.searchQuery fetchPlacesForSearchQuery: String
                                             completion:^(NSArray *places, NSError *error) {
                                                 if (error) {
                                                     NSLog(@"ERROR: %@", error);
                                                     [self handleSearchError:error];
                                                 } else {
                                                     self.searchResults = places;
                                                     [self.tableView reloadData];
                                                 }
     
                                                 
                }];
            return YES;
        
        }
     }
    
  return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
}

- (IBAction)btnClearClick:(id)sender {

   _txtAddress.text = @"";

}
- (IBAction)btnNextClick:(id)sender {
    
    if (_txtAddress.text.length==0) {
        
       [Utility showAlertWithTitle:nil withMessage:@"Please select address."];

    }else{
        
        NSLog(@"%@",self.txtAddress.text);
        YourHomeVC *objYourVC =[[YourHomeVC alloc] initWithNibName:@"YourHomeVC" bundle:nil];
        objYourVC.Address=self.txtAddress.text;
        [UserDefault setObject:CHECK_NULL_STRING(self.txtAddress.text) forKey:ADDRESS];
        [self.navigationController pushViewController:objYourVC animated:true];

    }
}

-(void)handleSearchError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription
    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
