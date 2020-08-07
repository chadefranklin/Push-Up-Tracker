//
//  GroupViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/4/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "GroupViewController.h"
#import <Parse/Parse.h>
#import "GroupCompletedSetsViewController.h"
#import "GroupGoalsViewController.h"

@interface GroupViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *groupPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxContributorLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPushupsLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self.group.creator.objectId isEqualToString:PFUser.currentUser.objectId]){
        NSLog(@"My Group");
        self.editButton.enabled = YES;
    } else {
        NSLog(@"Not My Group");
        self.editButton.enabled = NO;
    }

    self.groupNameLabel.text = self.group.name;
    self.groupPictureImageView.file = self.group[@"image"];
    [self.groupPictureImageView loadInBackground];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.totalPushupsLabel.text = [@"Total Pushups: " stringByAppendingString:[self.group.totalPushups stringValue]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toEditGroupSegue"]) {
        EditGroupViewController *editGroupViewController = (EditGroupViewController*)[segue destinationViewController];
        editGroupViewController.delegate = self;
        editGroupViewController.group = self.group;
    } else if([segue.identifier isEqualToString:@"toGroupCompletedSetsSegue"]){
        GroupCompletedSetsViewController *groupCompletedSetsViewController = (GroupCompletedSetsViewController*)[segue destinationViewController];
        groupCompletedSetsViewController.group = self.group;
    } else if([segue.identifier isEqualToString:@"toGroupGoalsSegue"]){
        GroupGoalsViewController *groupGoalsViewController = (GroupGoalsViewController*)[segue destinationViewController];
        groupGoalsViewController.group = self.group;
    }
}

- (void)didEditGroup:(Group *)group{
    NSLog(@"new group name:");
    NSLog(group.name);
    
    self.groupNameLabel.text = group.name;
    self.groupPictureImageView.file = group[@"image"];
    [self.groupPictureImageView loadInBackground];
}


@end
