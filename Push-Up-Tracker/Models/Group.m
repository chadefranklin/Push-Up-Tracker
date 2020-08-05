//
//  Group.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/23/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "Group.h"
#import "CEFPFFileObjectHelper.h"

@implementation Group

@dynamic creator;
@dynamic image;
@dynamic createdAt;
@dynamic name;
@dynamic code;
@dynamic totalPushups;

+ (nonnull NSString *)parseClassName {
    return @"Group";
}

+ (void) createGroup: ( NSString * _Nullable )name withCode: ( NSString * _Nullable )code withImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Group *newGroup = [Group new];
    newGroup.creator = [PFUser currentUser];
    newGroup.image = [CEFPFFileObjectHelper getPFFileFromImage:image];
    newGroup.name = name;
    newGroup.code = code;
    newGroup.totalPushups = @(0);
    
    PFRelation *relation = [newGroup relationForKey:@"members"];
    [relation addObject:[PFUser currentUser]];
    
    [newGroup saveInBackgroundWithBlock: completion];
}

@end
