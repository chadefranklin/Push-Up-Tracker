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
@dynamic deadline;
@dynamic createdAt;
@dynamic group;
@dynamic creator;

+ (nonnull NSString *)parseClassName {
    return @"Goal";
}

+ (Goal *) createGoal: ( NSNumber * _Nullable )pushupTarget withDeadline:( NSDate * _Nullable )deadline withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Goal *newGoal = [Goal new];
    newGoal.pushupTarget = pushupTarget;
    newGoal.pushupAmount = @(0);
    newGoal.creator = [PFUser currentUser];
    newGoal.deadline = deadline;
    
    [newGoal saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        PFRelation *relation = [[PFUser currentUser] relationForKey:@"goals"];
        [relation addObject:newGoal];
        
        [PFUser.currentUser saveInBackgroundWithBlock:completion];
    }];
    
    return newGoal;
}

+ (Goal *) createGoalForGroup:( Group * _Nullable )group withPushupTarget:( NSNumber * _Nullable )pushupTarget withDeadline:( NSDate * _Nullable )deadline withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Goal *newGoal = [Goal new];
    newGoal.pushupTarget = pushupTarget;
    newGoal.pushupAmount = @(0);
    //newGoal.creator = [PFUser currentUser];
    newGoal.group = group;
    newGoal.deadline = deadline;
    
    [newGoal saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        PFRelation *relation = [group relationForKey:@"goals"];
        [relation addObject:newGoal];
        
        [group saveInBackgroundWithBlock:completion];
    }];
    
    return newGoal;
}

@end
