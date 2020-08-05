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

@interface GroupsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;

@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.groupsTableView.dataSource = self;
    self.groupsTableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchGroups) forControlEvents:UIControlEventValueChanged];
    //[self.moviesTableView addSubview:self.refreshControl];
    [self.groupsTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchGroups];
}



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
            self.groups = groups;
            [self.groupsTableView reloadData];
        }
        else {
            // handle error
        }
        
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    
    PFObject *group = self.groups[indexPath.row];
    
    [cell setGroup:group];
        
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
    }
}


@end
