//
//  Group.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/23/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "Group.h"

@implementation Group

@dynamic creator;
@dynamic image;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Group";
}

@end
