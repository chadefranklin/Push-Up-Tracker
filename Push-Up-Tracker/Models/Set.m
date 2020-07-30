//
//  Set.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/28/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "Set.h"
#import "Group.h"

@implementation Set

@dynamic creator;
@dynamic image;
@dynamic video;
@dynamic pushupAmount;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Set";
}

//TODO: create set, have a NSARRAY of Groups to add relations to
+ (void) createSet: ( NSNumber * _Nullable )pushupAmount withVideoURL: ( NSURL * _Nullable )videoURL withImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Set *newSet = [Set new];
    newSet.creator = [PFUser currentUser];
    newSet.image = [self getPFFileFromImage:image];
    newSet.video = [self getPFFileFromVideoFileURL:videoURL];
    
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
                // maybe increment a totalPushups int on the group
                
                [groups[i] saveInBackground];
            }
        }
        else {
            // handle error
        }
    }];
    
    [newSet saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    //return [PFFileObject fileWithName:@"image.png" data:imageData];
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (PFFileObject *)getPFFileFromVideoFileURL: (NSURL * _Nullable)path {
 
    // check if path is not nil
    if (!path) {
        return nil;
    }
    
    //NSData *videoData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:<#(NSError *__autoreleasing  _Nullable * _Nullable)#>];
    NSData *videoData = [NSData dataWithContentsOfURL:path];
    if (!videoData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"video.mp4" data:videoData contentType:@"video/mp4"];
}

@end
