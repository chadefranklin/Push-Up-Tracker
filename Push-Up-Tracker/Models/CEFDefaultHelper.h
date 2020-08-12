//
//  CEFDefaultHelper.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/12/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static double const PUSHUP_SPEED_SLOW = 1.25;
static double const PUSHUP_SPEED_MEDIUM = 1;
static double const PUSHUP_SPEED_FAST = 0.75;


@interface CEFDefaultHelper : NSObject

+ (NSInteger)getVoiceUserDefault;
+ (void)setVoiceUserDefault:(NSInteger)index;
+ (NSInteger)getPushupSpeedUserDefault;
+ (void)setPushupSpeedUserDefault:(NSInteger)index;
+ (BOOL)voiceUserDefaultExists;
+ (BOOL)pushupSpeedUserDefaultExists;

@end

NS_ASSUME_NONNULL_END
