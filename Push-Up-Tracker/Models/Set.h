//
//  Set.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/28/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Set : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *creator;

@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) PFFileObject *video;
@property (nonatomic, strong) NSNumber *pushupAmount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *likes;

+ (void) createSet: ( NSNumber * _Nullable )pushupAmount withVideoURL: ( NSURL * _Nullable )videoURL withImage: ( UIImage * _Nullable )image withLatitude:( NSNumber * _Nullable )latitude withLongitude:( NSNumber * _Nullable )longitude withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
