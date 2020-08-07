//
//  ProfileGoalsViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "ProfileGoalsViewController.h"
#import <Parse/Parse.h>
#import "Goal.h"
#import "GoalCell.h"
#import "MBProgressHUD.h"

@interface ProfileGoalsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *goalsTableView;

@property (nonatomic, strong) NSMutableArray *goals;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileGoalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.goalsTableView.dataSource = self;
    self.goalsTableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchGoals) forControlEvents:UIControlEventValueChanged];
    //[self.moviesTableView addSubview:self.refreshControl];
    [self.goalsTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchGoals];
}



- (void)fetchGoals{
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"goals"];

    // generate a query based on that relation
    PFQuery *goalQuery = [relation query];
    [goalQuery orderByDescending:@"createdAt"];

    // now execute the query
    // fetch data asynchronously
    [goalQuery findObjectsInBackgroundWithBlock:^(NSArray<Goal *> * _Nullable goals, NSError * _Nullable error) {
        if (goals) {
            // do something with the data fetched
            self.goals = goals;
            [self.goalsTableView reloadData];
        }
        else {
            // handle error
        }
        
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoalCell"];
    
    PFObject *goal = self.goals[indexPath.row];
    
    [cell setGoal:goal];
        
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toAddGoalSegue"]) {
        AddGoalViewController *addGoalViewController = (AddGoalViewController*)[segue destinationViewController];
        addGoalViewController.delegate = self;
    }
}

- (void)didAddGoal:(NSNumber *)pushupAmount withDeadline:(NSDate *)deadline{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block __weak Goal *newGoal = nil;
    
    newGoal = [Goal createGoal:pushupAmount withDeadline:deadline withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"successfully created goal");
            [self.goals insertObject:newGoal atIndex:0];
            [self.goalsTableView reloadData];
        } else {
            NSLog(@"failed to create goal");
            NSLog(error.description);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


@end
