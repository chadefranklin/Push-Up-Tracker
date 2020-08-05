//
//  Set.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/28/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "Set.h"
#import "Group.h"
#import "CEFPFFileObjectHelper.h"

@implementation Set

@dynamic creator;
@dynamic image;
@dynamic video;
@dynamic pushupAmount;
@dynamic createdAt;
@dynamic objectId;

+ (nonnull NSString *)parseClassName {
    return @"Set";
}

//TODO: create set, have a NSARRAY of Groups to add relations to
+ (void) createSet: ( NSNumber * _Nullable )pushupAmount withVideoURL: ( NSURL * _Nullable )videoURL withImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Set *newSet = [Set new];
    newSet.pushupAmount = pushupAmount;
    newSet.creator = [PFUser currentUser];
    newSet.image = [CEFPFFileObjectHelper getPFFileFromImage:image];
    newSet.video = [CEFPFFileObjectHelper getPFFileFromVideoFileURL:videoURL];
    
    // get groups that I am a member of and add my set to it via relation
    // construct PFQuery
    PFQuery *groupQuery = [Group query];
    [groupQuery orderByDescending:@"createdAt"];
    NSArray<NSString *> *keys = @[@"name"];
    [groupQuery selectKeys:keys];
    [groupQuery whereKey:@"members" equalTo:[PFUser currentUser]];

    // fetch data asynchronously
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray<Group *> * _Nullable groups, NSError * _Nullable error) {
        if (groups) {
            // do something with the data fetched
            for(int i = 0; i < groups.count; i++){
                PFRelation *relation = [groups[i] relationForKey:@"sets"];
                [relation addObject:newSet];
                [groups[i] incrementKey:@"totalPushups" byAmount:pushupAmount];
                // increment pushupAmount on the current goal
                
                //[groups[i] saveInBackground];
            }
            [PFObject saveAllInBackground:groups];
        }
        else {
            // handle error
        }
    }];
    
    // ask about this
    [PFUser.currentUser incrementKey:@"totalPushups" byAmount:pushupAmount];
    if(pushupAmount > PFUser.currentUser[@"maxPushups"]){
        PFUser.currentUser[@"maxPushups"] = pushupAmount;
    }
    [PFUser.currentUser saveInBackground];
    
    [newSet saveInBackgroundWithBlock: completion];
}

@end
