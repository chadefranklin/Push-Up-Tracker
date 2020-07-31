//
//  SetDetailsViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/30/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "SetDetailsViewController.h"
#import "Set.h"
//#import "SetCell.h"
#import <Parse/Parse.h>
#import "DateTools.h"

@interface SetDetailsViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet PFImageView *imagePreviewImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushupAmountLabel;

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
}

- (IBAction)onPlayPressed:(id)sender {
    
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
