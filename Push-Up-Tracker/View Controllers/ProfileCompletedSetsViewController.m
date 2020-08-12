//
//  ProfileCompletedSetsViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/28/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "ProfileCompletedSetsViewController.h"
#import "Set.h"
#import "SetCell.h"
#import "SetDetailsViewController.h"

@interface ProfileCompletedSetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *setsTableView;

@property (nonatomic, strong) NSMutableArray *sets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation ProfileCompletedSetsViewController

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
    
    //TODO: Use Relation for Profile Sets instead of finding based on creator
    // construct PFQuery
    PFQuery *setQuery = [Set query];
    [setQuery orderByDescending:@"createdAt"];
    NSArray<NSString *> *keys = @[@"image", @"pushupAmount", @"createdAt", @"objectId", @"creator", @"likes", @"creator.username", @"creator.profileImage"];
    [setQuery selectKeys:keys];
    [setQuery whereKey:@"creator" equalTo:self.user];
    setQuery.limit = 12;

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
    //TODO: Use Relation for Profile Sets instead of finding based on creator
    // construct PFQuery
    PFQuery *setQuery = [Set query];
    [setQuery orderByDescending:@"createdAt"];
    NSArray<NSString *> *keys = @[@"image", @"pushupAmount", @"createdAt", @"objectId", @"creator", @"likes", @"creator.username", @"creator.profileImage"];
    [setQuery selectKeys:keys];
    [setQuery whereKey:@"creator" equalTo:self.user];
    Set *lastSet = self.sets.lastObject;
    [setQuery whereKey:@"createdAt" lessThan:lastSet.createdAt];
    setQuery.limit = 12;

    // fetch data asynchronously
    [setQuery findObjectsInBackgroundWithBlock:^(NSArray<Set *> * _Nullable sets, NSError * _Nullable error) {
        if (sets) {
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
    
    [cell setSet:set];
        
    return cell;
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
    }
}


@end
