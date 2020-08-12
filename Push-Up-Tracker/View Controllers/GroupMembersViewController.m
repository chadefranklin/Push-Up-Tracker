//
//  GroupMembersViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/12/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "GroupMembersViewController.h"
#import "GroupMemberCell.h"
#import "OtherProfileViewController.h"
#import <Parse/Parse.h>

@interface GroupMembersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *membersTableView;

@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation GroupMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.membersTableView.dataSource = self;
    self.membersTableView.delegate = self;
    
    [self fetchMembers];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMembers) forControlEvents:UIControlEventValueChanged];
    //[self.moviesTableView addSubview:self.refreshControl];
    [self.membersTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchMembers{
    NSLog(@"fetch members");
    self.isMoreDataLoading = true;
    
    // create a relation based on the authors key
    PFRelation *relation = [self.group relationForKey:@"members"];

    // generate a query based on that relation
    PFQuery *memberQuery = [relation query];
    [memberQuery orderByDescending:@"username"];
    NSArray<NSString *> *keys = @[@"username", @"profileImage", @"totalPushups", @"maxPushups"];
    [memberQuery selectKeys:keys];
    memberQuery.limit = 16;

    // now execute the query
    // fetch data asynchronously
    [memberQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable members, NSError * _Nullable error) {
        if (members) {
            // do something with the data fetched
            self.members = members;
            [self.membersTableView reloadData];
        }
        else {
            // handle error
        }
        
        [self.refreshControl endRefreshing];
        self.isMoreDataLoading = false;
    }];
}

- (void)fetchMoreMembers{
    self.isMoreDataLoading = true;
    
    // create a relation based on the authors key
    PFRelation *relation = [self.group relationForKey:@"members"];

    // generate a query based on that relation
    PFQuery *memberQuery = [relation query];
    [memberQuery orderByDescending:@"username"];
    NSArray<NSString *> *keys = @[@"username", @"profileImage"];
    [memberQuery selectKeys:keys];
    PFUser *lastUser = self.members.lastObject;
    //NSLog(lastSet.createdAt.description);
    [memberQuery whereKey:@"username" lessThan:lastUser.username];
    memberQuery.limit = 16;

    // now execute the query
    // fetch data asynchronously
    [memberQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable members, NSError * _Nullable error) {
        if (members) {
            // do something with the data fetched
            [self.members addObjectsFromArray:members];
            [self.membersTableView reloadData];
        }
        else {
            // handle error
        }
        
        [self.refreshControl endRefreshing];
        self.isMoreDataLoading = false;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMemberCell"];
    
    PFUser *groupMember = self.members[indexPath.row]; // used to be PFObject
    
    //cell.groupCompletedSetsViewController = self;
    [cell setMember:groupMember];
        
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading && self.members && self.members.count > 0){
         // Calculate the position of one screen length before the bottom of the results
         int scrollViewContentHeight = self.membersTableView.contentSize.height;
         int scrollOffsetThreshold = scrollViewContentHeight - self.membersTableView.bounds.size.height;
         
         // When the user has scrolled past the threshold, start requesting
         if(scrollView.contentOffset.y > scrollOffsetThreshold && self.membersTableView.isDragging) {
             //self.isMoreDataLoading = true;
             
             [self fetchMoreMembers];
         }
     }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"toOtherProfileSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.membersTableView indexPathForCell:tappedCell];
        PFUser *member = self.members[indexPath.row];
        
        OtherProfileViewController *otherProfileViewController = (OtherProfileViewController*)[segue destinationViewController];
        otherProfileViewController.user = member;
    }
}


@end
