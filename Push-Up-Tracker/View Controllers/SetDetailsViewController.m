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

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic) AVPlayer *aVPlayer;
@end

@implementation SetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playButton.enabled = NO;
    
    self.usernameLabel.text = self.set.creator.username;
    self.imagePreviewImageView.file = self.set[@"image"];
    [self.imagePreviewImageView loadInBackground];
    
    self.timestampLabel.text = [self.set.createdAt timeAgoSinceNow];
    
    
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
        } else {
            // Failure!
        }
    }];
     
}

- (IBAction)onPlayPressed:(id)sender {
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    controller.player = self.aVPlayer;
    [self.aVPlayer play];
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
