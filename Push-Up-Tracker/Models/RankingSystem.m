//
//  RankingSystem.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "RankingSystem.h"

@implementation RankingSystem

+ (NSString *)getRankForMaxPushups:(NSNumber *)maxPushups{
    switch([maxPushups intValue]){
        case 0 ... 19:
            return @"Rookie";
        case 20 ... 39:
            return @"Novice";
        case 40 ... 59:
            return @"Skilled";
        case 60 ... 79:
            return @"Advanced";
        case 80 ... 99:
            return @"Expert";
        case 100 ... 999999:
            return @"Master";
       default:
            return @"Novice";
    }
}

@end
