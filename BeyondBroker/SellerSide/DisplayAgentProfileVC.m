//
//  DisplayAgentProfileVC.m
//  BeyondBroker
//
//  Created by Webcore Solution on 16/06/17.
//  Copyright © 2017 Sarthak Patel. All rights reserved.
//

#import "DisplayAgentProfileVC.h"
#import "Utility.h"
#import "WebServiceCall.h"
#import "AppDelegate.h"
#import "AgentZillowCell.h"
#import "XMLReader.h"
#import "HomeTypesCell.h"
#import <UIKit/UIKit.h>
#import "HCYoutubeParser.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "RateView.h"
#import "AgentDetailVC.h"
#import "UIImageView+WebCache.h"
@interface DisplayAgentProfileVC (){
    NSURL *_urlToLoad;
}

@end

@implementation DisplayAgentProfileVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [tblview setTableHeaderView:tblHeaderView];
    [self registerNibForCustomCell];
    
    
    NSString *strImg=self.objAgentList.profileimg;
    NSString *Image = [strImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [imgUser sd_setImageWithURL:[NSURL URLWithString:Image]
                         placeholderImage:[UIImage imageNamed:Image]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
         imgUser.image=image;
         
     }];
    
    
    imgUser.layer.cornerRadius = imgUser.frame.size.width / 2;
    imgUser.clipsToBounds = YES;

    screenWidth=[[UIScreen mainScreen] bounds].size.width;
    cellSize = CGSizeMake((screenWidth/3)-20,70);
    [self.objCollectionView registerNib:[UINib nibWithNibName:@"HomeTypesCell" bundle:nil] forCellWithReuseIdentifier:@"HomeTypesCellId"];
    
    
    NSString *agentName=[NSString stringWithFormat:@"%@ %@",CHECK_NULL_STRING(self.objAgentList.firstname),CHECK_NULL_STRING(self.objAgentList.lastname)];
    lblAgentName.text=agentName;
    

    NSArray *arrSelectedAgent =[self.objAgentList.serviceprovided componentsSeparatedByString:@","];
    self.arrSelectedId =[[NSMutableArray alloc] initWithArray:arrSelectedAgent];
    NSLog(@"%@",self.arrSelectedId);
   
    [self GetZillowlistingData];

    
    NSString *urlstr=[NSString stringWithFormat:@"https://www.youtube.com/watch?v=k500CJruYjE"];
    NSString *formattedString = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    _playButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _playButton.layer.shadowOffset = CGSizeMake(0, 0);
    _playButton.layer.shadowOpacity = 0.7;
    _playButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:_playButton.bounds].CGPath;
    _playButton.layer.shadowRadius = 2;
    
    
    _urlToLoad = nil;
    [_playButton setImage:nil forState:UIControlStateNormal];
    
    NSURL *url = [NSURL URLWithString:formattedString];
    _activityIndicator.hidden = NO;
    [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
        
        if (!error) {
            [_playButton setBackgroundImage:image forState:UIControlStateNormal];
            
            [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                
                _playButton.hidden = NO;
                _activityIndicator.hidden = YES;
                
                NSDictionary *qualities = videoDictionary;
                
                NSString *URLString = nil;
                if ([qualities objectForKey:@"small"] != nil) {
                    URLString = [qualities objectForKey:@"small"];
                }
                else if ([qualities objectForKey:@"live"] != nil) {
                    URLString = [qualities objectForKey:@"live"];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                    return;
                }
                _urlToLoad = [NSURL URLWithString:URLString];
                
                [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }];

}
- (void)playVideo:(id)sender {
    if (_urlToLoad) {
        
        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:_urlToLoad];
        [self presentViewController:mp animated:YES completion:NULL];
        
    }
}

-(void)registerNibForCustomCell{
    
    UINib *nibListingCell=[UINib nibWithNibName:@"AgentZillowCell" bundle:nil];
    [tblview registerNib:nibListingCell forCellReuseIdentifier:@"AgentZillowCell"];
}
-(IBAction)btnQuickIntroClick:(id)sender {

    AgentDetailVC *objAgentDetailVC =[[AgentDetailVC alloc] initWithNibName:@"AgentDetailVC" bundle:nil];
    objAgentDetailVC.Title=@"Quick intro";
    objAgentDetailVC.Text=_objAgentList.quickintro;
    [self.navigationController pushViewController:objAgentDetailVC animated:true];

}
-(IBAction)btnExprienceClick:(id)sender {
  
    AgentDetailVC *objAgentDetailVC =[[AgentDetailVC alloc] initWithNibName:@"AgentDetailVC" bundle:nil];
    objAgentDetailVC.Title=@"Experience and education";
    objAgentDetailVC.Text=_objAgentList.education;
    [self.navigationController pushViewController:objAgentDetailVC animated:true];

}
-(IBAction)btnAboutMeClick:(id)sender {
   
    AgentDetailVC *objAgentDetailVC =[[AgentDetailVC alloc] initWithNibName:@"AgentDetailVC" bundle:nil];
    objAgentDetailVC.Title=@"Interesting Things About Me";
    objAgentDetailVC.Text=_objAgentList.aboutme;
    [self.navigationController pushViewController:objAgentDetailVC animated:true];

}
-(IBAction)btnBackClick:(id)sender {

   [self.navigationController popViewControllerAnimated:YES];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return cellSize;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrSelectedId.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTypesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTypesCellId" forIndexPath:indexPath];
    
    NSString *Title =[self.arrSelectedId objectAtIndex:indexPath.row];
    cell.lblTitle.text=CHECK_NULL_STRING(Title);
    cell.containerView.layer.borderWidth=1;
    cell.containerView.layer.borderColor=[UIColor grayColor].CGColor;
    cell.containerView.layer.cornerRadius=3.0f;
    [cell.containerView setBackgroundColor:[UIColor whiteColor]];
    cell.lblTitle.textColor=[UIColor darkGrayColor];

    return cell;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrZillow.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AgentZillowCell *Cell =  [tableView dequeueReusableCellWithIdentifier:@"AgentZillowCell"];
    NSString *reviewDate=[NSString stringWithFormat:@"%@",[[[self.arrZillow valueForKey:@"reviewDate"] valueForKey:@"text"]objectAtIndex:indexPath.row]];
    
    NSString *reviewer=[NSString stringWithFormat:@"%@",[[[self.arrZillow valueForKey:@"reviewer"] valueForKey:@"text"]objectAtIndex:indexPath.row]];
 
    Cell.lblDateAndViwer.text=[NSString stringWithFormat:@"%@ - %@",CHECK_NULL_STRING(reviewDate),CHECK_NULL_STRING(reviewer)];
    
    NSString *rating=[NSString stringWithFormat:@"%@",[[[self.arrZillow valueForKey:@"rating"] valueForKey:@"text"]objectAtIndex:indexPath.row]];
    
    RateView* rateVw = nil;
    rateVw = [RateView rateViewWithRating:0.0f];
    rateVw.frame = CGRectMake(0, Cell.rateView.frame.size.height/2 - 8, Cell.rateView.frame.size.width, Cell.rateView.frame.size.height);
    rateVw.starSize = 15;
    rateVw.tag = 88888;
    rateVw.rating = [rating floatValue];
    
    rateVw.starNormalColor = [UIColor whiteColor];
    rateVw.starFillColor = [Utility getColor:GREEN_COLOR];
    rateVw.starBorderColor = [Utility getColor:GREEN_COLOR];
    [Cell.rateView addSubview:rateVw];
    
    NSString *reviewSummary=[NSString stringWithFormat:@"%@",[[[self.arrZillow valueForKey:@"reviewSummary"] valueForKey:@"text"]objectAtIndex:indexPath.row]];
    Cell.lblSummary.text=[NSString stringWithFormat:@"%@",CHECK_NULL_STRING(reviewSummary)];
    
    NSString *description=[NSString stringWithFormat:@"%@",[[[self.arrZillow valueForKey:@"description"] valueForKey:@"text"]objectAtIndex:indexPath.row]];
    Cell.lblSummary.text=[NSString stringWithFormat:@"%@",CHECK_NULL_STRING(description)];

    return Cell;
}
-(void)GetZillowlistingData{
    
        NSString *zilowurl=[NSString stringWithFormat:@"http://www.zillow.com/webservice/ProReviews.htm?zws-id=X1-ZWz199vp77f763_6zfs6&screenname=%@",self.objAgentList.agent_zipper_profile];
        
        NSString *Url = [zilowurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.view endEditing:true];
        [[WebServiceCall getInstance] sendRequestWithUrl:Url withData:nil withMehtod:@"GET" withLoadingAlert:@"" withCompletionBlock:^(BOOL success, NSData *response, NSError *error) {
            
            NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            
            NSString *theXML = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSDictionary *dictResponce = [XMLReader dictionaryForXMLString:theXML error:&error];
            
            self.arrZillow=[[NSMutableArray alloc]init];
            
            if (success) {
                
               NSDictionary *dict=[[dictResponce valueForKey:@"ProReviews:proreviewresults"] valueForKey:@"response"];
               self.arrZillow =[[[dict valueForKey:@"result"] valueForKey:@"proReviews"]valueForKey:@"review"];
              
                NSString *avgRating = [NSString stringWithFormat:@"%@",[[[[dict valueForKey:@"result"]
                                                                          valueForKey:@"proInfo"]valueForKey:@"avgRating"] valueForKey:@"text"]];
                NSString *reviewCount =[NSString stringWithFormat:@"%@",[[[[dict valueForKey:@"result"] valueForKey:@"proInfo"]valueForKey:@"reviewCount"] valueForKey:@"text"]];
                
              
                NSString *recentSaleCount =[NSString stringWithFormat:@"%@",[[[[dict valueForKey:@"result"] valueForKey:@"proInfo"]valueForKey:@"recentSaleCount"] valueForKey:@"text"]];
                
                
                RateView* rateVw = nil;
                rateVw = [RateView rateViewWithRating:0.0f];
                rateVw.frame = CGRectMake(0, self.RateView.frame.size.height/2 - 8, self.RateView.frame.size.width, self.RateView.frame.size.height);
                rateVw.starSize = 15;
                rateVw.tag = 88888;
                rateVw.rating = [avgRating floatValue];
                
                rateVw.starNormalColor = [UIColor whiteColor];
                rateVw.starFillColor = [Utility getColor:GREEN_COLOR];
                rateVw.starBorderColor = [Utility getColor:GREEN_COLOR];
                [self.RateView addSubview:rateVw];
                
                _lblReview.text=CHECK_NULL_STRING(reviewCount);
                _lblRecentSales.text=CHECK_NULL_STRING(recentSaleCount);
                
                [tblview reloadData];
        }
    }];
}
@end
