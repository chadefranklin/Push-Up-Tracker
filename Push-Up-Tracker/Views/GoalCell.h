//
//  GoalCell.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
@import LinearProgressBar;

NS_ASSUME_NONNULL_BEGIN

@interface GoalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goalProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet LinearProgressBar *goalProgressBar;


@property (strong, nonatomic) Goal *goal;

@end

NS_ASSUME_NONNULL_END
