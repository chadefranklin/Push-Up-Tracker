//
//  CEFDateHelper.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/12/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CEFDateHelper : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (CEFDateHelper *)sharedObject;

- (NSString *)formatDate:(NSDate *)date withDateFormat:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
