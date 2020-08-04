//
//  CEFPFFileObjectHelper.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/3/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface CEFPFFileObjectHelper : NSObject

+ (CEFPFFileObjectHelper *)sharedObject;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
+ (PFFileObject *)getPFFileFromVideoFileURL: (NSURL * _Nullable)path;

@end

NS_ASSUME_NONNULL_END
