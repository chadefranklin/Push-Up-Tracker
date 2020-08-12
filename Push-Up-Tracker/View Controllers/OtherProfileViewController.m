//
//  OtherProfileViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "ProfileCompletedSetsViewController.h"
#import "RankingSystem.h"

@interface OtherProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *maxPushupsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPushupsLabel;

@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2.16f;
    
    self.usernameLabel.text = self.user.username;
    self.profileImageView.file = self.user[@"profileImage"];
    [self.profileImageView loadInBackground];
    
    self.totalPushupsLabel.text = [@"Total Pushups: " stringByAppendingString:[self.user[@"totalPushups"] stringValue]];
    self.maxPushupsLabel.text = [@"Max Pushups: " stringByAppendingString:[self.user[@"maxPushups"] stringValue]];
    self.rankLabel.text = [RankingSystem getRankForMaxPushups:self.user[@"maxPushups"]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"toProfileCompletedSetsSegue"]){
        ProfileCompletedSetsViewController *profileCompletedSetsViewController = (ProfileCompletedSetsViewController*)[segue destinationViewController];
        profileCompletedSetsViewController.user = [PFUser currentUser];
    }
}


@end
