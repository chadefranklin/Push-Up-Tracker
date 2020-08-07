//
//  GroupGoalsViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/6/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGoalViewController.h"
#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupGoalsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddGoalViewControllerDelegate>

@property (strong, nonatomic) Group *group;

@end

NS_ASSUME_NONNULL_END
