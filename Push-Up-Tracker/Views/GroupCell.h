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

@property (strong, nonatomic) Group *group;

- (void)setGroup:(Group *)group;
@end

NS_ASSUME_NONNULL_END
