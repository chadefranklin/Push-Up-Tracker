//
//  ProfileViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/16/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "CEFPFFileObjectHelper.h"
#import "ProfileCompletedSetsViewController.h"
#import "RankingSystem.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *maxPushupsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPushupsLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2.16;
    
    self.usernameLabel.text = [PFUser currentUser].username;
    self.profileImageView.file = PFUser.currentUser[@"profileImage"];
    [self.profileImageView loadInBackground];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.totalPushupsLabel.text = [@"Total Pushups: " stringByAppendingString:[PFUser.currentUser[@"totalPushups"] stringValue]];
    self.maxPushupsLabel.text = [@"Max Pushups: " stringByAppendingString:[PFUser.currentUser[@"maxPushups"] stringValue]];
    self.rankLabel.text = [RankingSystem getRankForMaxPushups:PFUser.currentUser[@"maxPushups"]];
}

- (IBAction)onLogOutPressed:(id)sender {
    NSLog(@"onLogOutPressed");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject.delegate;
            
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        sceneDelegate.window.rootViewController = loginViewController;
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"toProfileCompletedSetsSegue"]){
        ProfileCompletedSetsViewController *profileCompletedSetsViewController = (ProfileCompletedSetsViewController*)[segue destinationViewController];
        profileCompletedSetsViewController.user = [PFUser currentUser];
    } else if ([segue.identifier isEqualToString:@"toEditProfileSegue"]) {
        EditProfileViewController *editProfileViewController = (EditProfileViewController*)[segue destinationViewController];
        editProfileViewController.delegate = self;
    }
}

- (void)didEditUser{
    NSLog(@"didEditUser");
    
    self.usernameLabel.text = [PFUser currentUser].username;
    self.profileImageView.file = PFUser.currentUser[@"profileImage"];
    [self.profileImageView loadInBackground];
}


@end
