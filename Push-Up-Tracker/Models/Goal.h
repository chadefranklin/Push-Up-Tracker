//
//  Goal.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/31/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Parse/Parse.h>
#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface Goal : PFObject<PFSubclassing>

@property (nonatomic, strong) NSNumber *pushupTarget;
@property (nonatomic, strong) NSNumber *pushupAmount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) PFUser *creator;

@end

NS_ASSUME_NONNULL_END
