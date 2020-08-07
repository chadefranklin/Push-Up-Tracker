//
//  AddGoalViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/6/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddGoalViewControllerDelegate

- (void)didAddGoal:(NSNumber *)pushupAmount withDeadline:(NSDate *)deadline;

@end

@interface AddGoalViewController : UIViewController

@property (nonatomic, weak) id<AddGoalViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
