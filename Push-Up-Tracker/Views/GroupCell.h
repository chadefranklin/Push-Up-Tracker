//
//  GroupCell.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/24/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface GroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *exclamationMarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *goalsActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPushupsLabel;

@property (strong, nonatomic) Group *group;

- (void)setGroup:(Group *)group;
- (void)setInJeopardy;
- (void)setGoalsActive:(NSNumber *)goalsActive;

@end

NS_ASSUME_NONNULL_END
