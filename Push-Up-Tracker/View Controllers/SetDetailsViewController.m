//
//  SetDetailsViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/30/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "SetDetailsViewController.h"
//#import "SetCell.h"
#import <Parse/Parse.h>
#import "DateTools.h"

@interface SetDetailsViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet PFImageView *imagePreviewImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushupAmountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;


@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic) AVPlayer *aVPlayer;

@property (nonatomic) BOOL liked;

@end

@implementation SetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2;
    
    self.playButton.enabled = NO;
    
    self.usernameLabel.text = self.set.creator.username;
    self.pushupAmountLabel.text = [[self.set.pushupAmount stringValue] stringByAppendingString:@" Pushups"];
    self.imagePreviewImageView.file = self.set[@"image"];
    [self.imagePreviewImageView loadInBackground];
    self.profileImageView.file = self.set.creator[@"profileImage"];
    [self.profileImageView loadInBackground];
    
    self.timestampLabel.text = [self.set.createdAt timeAgoSinceNow];
    
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Set"];
    [query getObjectInBackgroundWithId:self.set.objectId block:^(PFObject *set, NSError *error) {
        if (!error) {
            // Success!
            self.set = set;
            
            // enable play button
            self.playButton.enabled = YES;
            
            NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"save.mov"];
            NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:outputPath])
            {
                NSError *error;
                if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
                {
                    //Error - handle if requried
                }
            }
            
            [self.set.video.getData writeToURL:outputURL atomically:YES];
            
            self.aVPlayer = [AVPlayer playerWithURL:outputURL];
            
            if(self.set.latitude && self.set.longitude){
                CLLocationCoordinate2D position = CLLocationCoordinate2DMake([self.set.latitude floatValue], [self.set.longitude floatValue]);
                GMSMarker *marker = [GMSMarker markerWithPosition:position];
                marker.title = @"Set Location";
                marker.map = self.mapView;
                
                //[self.mapView animateToLocation:position];
                [self.mapView moveCamera:[GMSCameraUpdate setTarget:marker.position]];
                [self.mapView animateToBearing:0];
                [self.mapView animateToViewingAngle:0];
                [self.mapView animateToZoom:4];
            }
        } else {
            // Failure!
        }
    }];
    
    PFRelation *likedRelation = [self.set relationForKey:@"liked"];
    PFQuery *likedQuery = [likedRelation query];
    [likedQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    likedQuery.limit = 1;

    [likedQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
        if (users && users.count > 0) {
            // do something with the data fetched
            NSLog(@"liked is equal");
            self.liked = YES;
        }
        else {
            // handle error
            NSLog(@"liked not equal");
            self.liked = NO;
        }
        [self updateLikes];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.likeImageView.alpha = 0;
}

- (IBAction)onPlayPressed:(id)sender {
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    controller.player = self.aVPlayer;
    [self.aVPlayer play];
}

- (IBAction)onLikePressed:(id)sender {
    if(self.liked){
        [self.set incrementKey:@"likes" byAmount:@(-1)];
        PFRelation *relation = [self.set relationForKey:@"liked"];
        [relation removeObject:[PFUser currentUser]];
        
        self.liked = NO;
    } else {
        [self.set incrementKey:@"likes"];
        PFRelation *relation = [self.set relationForKey:@"liked"];
        [relation addObject:[PFUser currentUser]];
        
        self.liked = YES;
    }
    [self.set saveInBackground];
    
    [self updateLikes];
}

- (IBAction)onImageDoubleTapped:(id)sender {
    NSLog(@"double tapped");
    if(!self.liked){
        [self.set incrementKey:@"likes"];
        PFRelation *relation = [self.set relationForKey:@"liked"];
        [relation addObject:[PFUser currentUser]];
        
        self.liked = YES;
        
        [self.set saveInBackground];
        
        [self updateLikes];
        
        [self likeAnimation];
    }
}


- (void)updateLikes{
    if(self.liked){
        [self.likeButton setTitle:[self.set.likes stringValue] forState:UIControlStateSelected];
    } else {
        [self.likeButton setTitle:[self.set.likes stringValue] forState:UIControlStateNormal];
    }
    self.likeButton.selected = self.liked;
}

- (void)likeAnimation{
    //likeImageView
    //__block CGRect zeroLikeFrame = self.likeImageView.frame;
    __block CGRect newLikeFrame = self.likeImageView.frame;
    
    newLikeFrame.size.width = 0;
    newLikeFrame.size.height = 0;
    self.likeImageView.frame = newLikeFrame;
    self.likeImageView.alpha = 1;
    
    newLikeFrame.size.width = 200;
    newLikeFrame.size.height = 200;
    [UIView animateWithDuration:0.8f animations:^{
        self.likeImageView.frame = newLikeFrame;
    }completion:^(BOOL finished){
        self.likeImageView.alpha = 0;
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
