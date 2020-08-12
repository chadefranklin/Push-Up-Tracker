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
#import "Goal.h"

@implementation Set

@dynamic creator;
@dynamic image;
@dynamic video;
@dynamic pushupAmount;
@dynamic createdAt;
@dynamic objectId;
@dynamic latitude;
@dynamic longitude;
@dynamic likes;

+ (nonnull NSString *)parseClassName {
    return @"Set";
}

//TODO: create set, have a NSARRAY of Groups to add relations to
+ (void) createSet: ( NSNumber * _Nullable )pushupAmount withVideoURL: ( NSURL * _Nullable )videoURL withImage: ( UIImage * _Nullable )image withLatitude:( NSNumber * _Nullable )latitude withLongitude:( NSNumber * _Nullable )longitude withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    // ask about this
    [PFUser.currentUser incrementKey:@"totalPushups" byAmount:pushupAmount];
    if([pushupAmount intValue] > [PFUser.currentUser[@"maxPushups"] intValue]){
        PFUser.currentUser[@"maxPushups"] = pushupAmount;
    }
    [PFUser.currentUser saveInBackground]; //
    
    
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"goals"];
    // generate a query based on that relation
    PFQuery *goalQuery = [relation query];
    [goalQuery orderByDescending:@"createdAt"];
    [goalQuery whereKey:@"deadline" greaterThan:[NSDate now]];

    // now execute the query
    // fetch data asynchronously
    [goalQuery findObjectsInBackgroundWithBlock:^(NSArray<Goal *> * _Nullable goals, NSError * _Nullable error) {
        if (goals) {
            // do something with the data fetched
            for(int i = 0; i < goals.count; i++){
                [goals[i] incrementKey:@"pushupAmount" byAmount:pushupAmount];
            }
            [PFObject saveAllInBackground:goals];
        }
        else {
            // handle error
        }
    }];
    
    
    
    Set *newSet = [Set new];
    newSet.pushupAmount = pushupAmount;
    newSet.creator = [PFUser currentUser];
    newSet.image = [CEFPFFileObjectHelper getPFFileFromImage:image];
    newSet.video = [CEFPFFileObjectHelper getPFFileFromVideoFileURL:videoURL];
    newSet.likes = @(0);
    if(latitude && longitude){
        newSet.latitude = latitude;
        newSet.longitude = longitude;
    }
    
    // get groups that I am a member of and add my set to it via relation
    // construct PFQuery
    PFQuery *groupQuery = [Group query];
    [groupQuery orderByDescending:@"createdAt"];
    NSArray<NSString *> *keys = @[@"name"];
    [groupQuery selectKeys:keys];
    [groupQuery whereKey:@"members" equalTo:[PFUser currentUser]];
    
    [newSet saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        // fetch data asynchronously
        [groupQuery findObjectsInBackgroundWithBlock:^(NSArray<Group *> * _Nullable groups, NSError * _Nullable error) {
            if (groups) {
                // do something with the data fetched
                for(int i = 0; i < groups.count; i++){
                    PFRelation *relation = [groups[i] relationForKey:@"sets"];
                    [relation addObject:newSet];
                    [groups[i] incrementKey:@"totalPushups" byAmount:pushupAmount];
                    
                    // increment pushupAmount on any current goals
                    PFRelation *groupGoalsRelation = [groups[i] relationForKey:@"goals"];
                    // generate a query based on that relation
                    PFQuery *groupGoalQuery = [groupGoalsRelation query];
                    [groupGoalQuery orderByDescending:@"createdAt"];
                    [groupGoalQuery whereKey:@"deadline" greaterThan:[NSDate now]];

                    // now execute the query
                    // fetch data asynchronously
                    [groupGoalQuery findObjectsInBackgroundWithBlock:^(NSArray<Goal *> * _Nullable goals, NSError * _Nullable error) {
                        if (goals) {
                            // do something with the data fetched
                            for(int i = 0; i < goals.count; i++){
                                [goals[i] incrementKey:@"pushupAmount" byAmount:pushupAmount];
                            }
                            [PFObject saveAllInBackground:goals];
                        }
                        else {
                            // handle error
                        }
                    }];
                    
                    //[groups[i] saveInBackground];
                }
                [PFObject saveAllInBackground:groups block:completion];
            }
            else {
                // handle error
            }
        }];
    }];
    
}

@end
