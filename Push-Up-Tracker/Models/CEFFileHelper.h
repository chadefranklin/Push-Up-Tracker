//
//  CEFFileHelper.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/3/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CEFFileHelper : NSObject

+ (CEFFileHelper *)sharedObject;

- (NSString *)getPushupSetOutputVideoPath;
- (NSURL *)getPushupSetOutputVideoPathURL;

@property (nonatomic, strong) NSString *outputPath;
@property (nonatomic, strong) NSURL *outputURL;

@end

NS_ASSUME_NONNULL_END
