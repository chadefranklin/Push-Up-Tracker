//
//  RankingSystem.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankingSystem : NSObject

+ (NSString *)getRankForMaxPushups:(NSNumber *)maxPushups;

@end

NS_ASSUME_NONNULL_END
