//
//  GroupCompletedSetsViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "GroupCompletedSetsViewController.h"
#import "Set.h"
#import "SetCell.h"
#import "SetDetailsViewController.h"
#import "OtherProfileViewController.h"
#import <Parse/Parse.h>

@interface GroupCompletedSetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *setsTableView;

@property (nonatomic, strong) NSMutableArray *sets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) PFUser *pressedUser;

@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation GroupCompletedSetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.setsTableView.dataSource = self;
    self.setsTableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchSets) forControlEvents:UIControlEventValueChanged];
    //[self.moviesTableView addSubview:self.refreshControl];
    [self.setsTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchSets];
}

- (void)fetchSets{
    self.isMoreDataLoading = true;
    
    // create a relation based on the authors key
    PFRelation *relation = [self.group relationForKey:@"sets"];

    // generate a query based on that relation
    PFQuery *setQuery = [relation query];
    [setQuery orderByDescending:@"createdAt"];
    NSArray<NSString *> *keys = @[@"image", @"pushupAmount", @"createdAt", @"objectId", @"creator", @"creator.username", @"creator.profileImage", @"creator.maxPushups", @"creator.totalPushups"];
    [setQuery selectKeys:keys];
    setQuery.limit = 12;

    // now execute the query
    // fetch data asynchronously
    [setQuery findObjectsInBackgroundWithBlock:^(NSArray<Set *> * _Nullable sets, NSError * _Nullable error) {
        if (sets) {
            // do something with the data fetched
            self.sets = sets;
            [self.setsTableView reloadData];
        }
        else {
            // handle error
        }
        
        [self.refreshControl endRefreshing];
        self.isMoreDataLoading = false;
    }];
}

- (void)fetchMoreSets{
    self.isMoreDataLoading = true;
    
    NSLog(@"fetch more sets");
    // create a relation based on the authors key
    PFRelation *relation = [self.group relationForKey:@"sets"];

    // generate a query based on that relation
    PFQuery *setQuery = [relation query];
    [setQuery orderByDescending:@"createdAt"];
    NSArray<NSString *> *keys = @[@"image", @"pushupAmount", @"createdAt", @"objectId", @"creator", @"creator.username", @"creator.profileImage", @"creator.maxPushups", @"creator.totalPushups"];
    [setQuery selectKeys:keys];
    Set *lastSet = self.sets.lastObject;
    //NSLog(lastSet.createdAt.description);
    [setQuery whereKey:@"createdAt" lessThan:lastSet.createdAt];
    setQuery.limit = 12;

    // now execute the query
    // fetch data asynchronously
    [setQuery findObjectsInBackgroundWithBlock:^(NSArray<Set *> * _Nullable sets, NSError * _Nullable error) {
        if (sets) {
            NSLog(@"%d", sets.count);
            // do something with the data fetched
            [self.sets addObjectsFromArray:sets];
            [self.setsTableView reloadData];
        }
        else {
            // handle error
        }
        
        [self.refreshControl endRefreshing];
        self.isMoreDataLoading = false;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"];
    
    PFObject *set = self.sets[indexPath.row];
    
    cell.groupCompletedSetsViewController = self;
    [cell setSet:set];
        
    return cell;
}

- (void)profilePicturePressed:(PFUser *)user{
    self.pressedUser = user;
    
    [self performSegueWithIdentifier:@"toOtherProfileSegue" sender:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading && self.sets && self.sets.count > 0){
         // Calculate the position of one screen length before the bottom of the results
         int scrollViewContentHeight = self.setsTableView.contentSize.height;
         int scrollOffsetThreshold = scrollViewContentHeight - self.setsTableView.bounds.size.height;
         
         // When the user has scrolled past the threshold, start requesting
         if(scrollView.contentOffset.y > scrollOffsetThreshold && self.setsTableView.isDragging) {
             //self.isMoreDataLoading = true;
             
             [self fetchMoreSets];
         }
     }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toSetDetailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.setsTableView indexPathForCell:tappedCell];
        Set *set = self.sets[indexPath.row];
        
        SetDetailsViewController *setDetailsViewController = (SetDetailsViewController*)[segue destinationViewController];
        setDetailsViewController.set = set;
    } else if([segue.identifier isEqualToString:@"toOtherProfileSegue"]){
        OtherProfileViewController *otherProfileViewController = (OtherProfileViewController*)[segue destinationViewController];
        otherProfileViewController.user = self.pressedUser;
    }
}


@end
