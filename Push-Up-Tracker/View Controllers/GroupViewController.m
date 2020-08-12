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
#import "Goal.h"
#import "GroupMembersViewController.h"
#import "CEFGoalHelper.h"

@interface GroupViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *groupPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *highestMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *highestTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPushupsLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIImageView *goalsExclamationImageView;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.groupPictureImageView.layer.masksToBounds = YES;
    self.groupPictureImageView.layer.cornerRadius = self.groupPictureImageView.bounds.size.width / 2.16f;
    
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
    
    self.goalsExclamationImageView.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.group fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        Group *g = object;
        
        self.totalPushupsLabel.text = [@"Total Pushups: " stringByAppendingString:[g.totalPushups stringValue]];
    }];
    
    PFRelation *membersRelation = [self.group relationForKey:@"members"];
    PFQuery *highestMaxQuery = [membersRelation query];
    //[mostQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [highestMaxQuery orderByDescending:@"maxPushups"];
    [highestMaxQuery includeKey:@"username"];
    //[highestMaxQuery includeKey:@"members.username"];
    highestMaxQuery.limit = 1;

    [highestMaxQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
        if (users && users.count > 0) {
            // do something with the data fetched
            self.highestMaxLabel.text = [@"Highest Max: " stringByAppendingString:users[0].username];
        }
    }];
    
    PFQuery *highestTotalQuery = [membersRelation query];
    //[mostQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [highestTotalQuery orderByDescending:@"totalPushups"];
    [highestTotalQuery includeKey:@"username"];
    //[highestMaxQuery includeKey:@"members.username"];
    highestTotalQuery.limit = 1;
    
    [highestTotalQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
        if (users && users.count > 0) {
            // do something with the data fetched
            self.highestTotalLabel.text = [@"Highest Total: " stringByAppendingString:users[0].username];
        }
    }];
    
    [self checkGoalsInJeopardy];
}

- (void)checkGoalsInJeopardy{
    PFRelation *goalsRelation = [self.group relationForKey:@"goals"];
    PFQuery *goalsQuery = [goalsRelation query];
    [goalsQuery orderByDescending:@"createdAt"];
    [goalsQuery whereKey:@"deadline" greaterThan:[NSDate now]];

    [goalsQuery findObjectsInBackgroundWithBlock:^(NSArray<Goal *> * _Nullable goals, NSError * _Nullable error) {
        if (goals) {
            // do something with the data fetched
            BOOL inJeopardy = NO;
            for(int i = 0; i < goals.count; i++){
                if([CEFGoalHelper checkIfGoalInJeopardy:goals[i]]){
                    inJeopardy = YES;
                    break;
                }
            }
            if(inJeopardy){
                self.goalsExclamationImageView.alpha = 1;
            } else {
                self.goalsExclamationImageView.alpha = 0;
            }
        }
        else {
            // handle error
            self.goalsExclamationImageView.alpha = 0;
        }
    }];
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
    } else if ([segue.identifier isEqualToString:@"toGroupMembersSegue"]) {
        GroupMembersViewController *groupMembersViewController = (GroupMembersViewController*)[segue destinationViewController];
        groupMembersViewController.group = self.group;
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
