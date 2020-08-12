//
//  GroupsViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/23/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "GroupsViewController.h"
#import <Parse/Parse.h>
#import "Group.h"
#import "GroupCell.h"
#import "GroupViewController.h"
#import "Goal.h"
#import "CEFGoalHelper.h"

@interface GroupsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;

@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSMutableArray *groupsInJeopardy;
@property (nonatomic, strong) NSMutableArray *groupsActiveGoals;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.groupsTableView.dataSource = self;
    self.groupsTableView.delegate = self;
    
    [self fetchGroups];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchGroups) forControlEvents:UIControlEventValueChanged];
    //[self.moviesTableView addSubview:self.refreshControl];
    [self.groupsTableView insertSubview:self.refreshControl atIndex:0];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    [self fetchGroups];
//}



- (void)fetchGroups{
    // construct PFQuery
    PFQuery *groupQuery = [Group query];
    [groupQuery orderByDescending:@"createdAt"];
    //NSArray<NSString *> *keys = @[@"name", @"groupImage"];
    NSArray<NSString *> *keys = @[@"name", @"code", @"image", @"totalPushups", @"creator"];
    [groupQuery selectKeys:keys];
    [groupQuery whereKey:@"members" equalTo:[PFUser currentUser]];

    // fetch data asynchronously
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray<Group *> * _Nullable groups, NSError * _Nullable error) {
        if (groups) {
            // do something with the data fetched
            self.groupsInJeopardy = [NSMutableArray arrayWithCapacity:groups.count];
            self.groupsActiveGoals = [NSMutableArray arrayWithCapacity:groups.count];
            for (int i = 0; i < groups.count; i++) {
                [self.groupsInJeopardy addObject:@(NO)];
                [self.groupsActiveGoals addObject:@(0)];
            }
            
            self.groups = groups;
            [self.groupsTableView reloadData];
            
            [self checkGoalsInJeopardyAndActiveGoals];
        }
        else {
            // handle error
        }
        
        [self.refreshControl endRefreshing];
    }];
}

- (void)checkGoalsInJeopardyAndActiveGoals{
    for(int i = 0; i < self.groups.count; i++){
        PFRelation *goalsRelation = [self.groups[i] relationForKey:@"goals"];
        PFQuery *goalsQuery = [goalsRelation query];
        [goalsQuery orderByDescending:@"createdAt"];
        [goalsQuery whereKey:@"deadline" greaterThan:[NSDate now]];

        [goalsQuery findObjectsInBackgroundWithBlock:^(NSArray<Goal *> * _Nullable goals, NSError * _Nullable error) {
            if (goals) {
                // do something with the data fetched
                NSLog(@"goals count: ");
                NSLog(@"%d", goals.count);
                [self.groupsActiveGoals replaceObjectAtIndex:i withObject:@(goals.count)];
                
                BOOL inJeopardy = NO;
                for(int j = 0; j < goals.count; j++){
                    //if([self checkIfGoalInJeopardy:goals[j]]){
                    if([CEFGoalHelper checkIfGoalInJeopardy:goals[j]]){
                        inJeopardy = YES;
                        break;
                    }
                }
                if(inJeopardy){
                    [self.groupsInJeopardy replaceObjectAtIndex:i withObject:@(YES)];
                } else {
                    [self.groupsInJeopardy replaceObjectAtIndex:i withObject:@(NO)];
                }
            }
            else {
                // handle error
                [self.groupsInJeopardy replaceObjectAtIndex:i withObject:@(NO)];
            }
            
            [self.groupsTableView reloadData];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    
    PFObject *group = self.groups[indexPath.row];
    
    [cell setGroup:group];
    
    if(self.groupsInJeopardy && self.groupsInJeopardy[indexPath.row] && [[self.groupsInJeopardy objectAtIndex:indexPath.row] boolValue] == YES){
        [cell setInJeopardy];
    }
    if(self.groupsActiveGoals && self.groupsActiveGoals[indexPath.row]){
        [cell setGoalsActive:self.groupsActiveGoals[indexPath.row]];
    }
        
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toGroupSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.groupsTableView indexPathForCell:tappedCell];
        Group *group = self.groups[indexPath.row];
        
        GroupViewController *groupViewController = (GroupViewController*)[segue destinationViewController];
        groupViewController.group = group;
    } else if ([segue.identifier isEqualToString:@"toAddGroupSegue"]) {
        AddGroupViewController *addGroupViewController = (AddGroupViewController*)[segue destinationViewController];
        addGroupViewController.delegate = self;
    }
}

- (void)didAddGroup{
    [self fetchGroups];
}


@end
