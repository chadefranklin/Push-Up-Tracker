//
//  Goal.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/31/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "Goal.h"

@implementation Goal

@dynamic pushupTarget;
@dynamic pushupAmount;
@dynamic createdAt;
@dynamic group;
@dynamic creator;

+ (nonnull NSString *)parseClassName {
    return @"Goal";
}

@end
