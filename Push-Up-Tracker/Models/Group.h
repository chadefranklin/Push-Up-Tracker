//
//  Group.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/23/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Group : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *creator;

@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;

+ (void) createGroup: ( NSString * _Nullable )name withCode: ( NSString * _Nullable )code withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
