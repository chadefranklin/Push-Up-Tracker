//
//  CEFGoalHelper.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/11/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "CEFGoalHelper.h"

@implementation CEFGoalHelper

+ (BOOL)checkIfGoalInJeopardy:(Goal *)goal{
    NSDate *now = [NSDate now];
    int initialSeconds = [goal.deadline timeIntervalSinceDate:goal.createdAt];
    int remainingSeconds = initialSeconds - [now timeIntervalSinceDate:goal.createdAt];
    
    float normalizedTimeRemaining = remainingSeconds / (float)initialSeconds;
    float normalizedPushupsRemaining = ([goal.pushupTarget floatValue] - [goal.pushupAmount floatValue]) / [goal.pushupTarget floatValue];
    
    if(remainingSeconds < initialSeconds / 2){
        if(normalizedPushupsRemaining > normalizedTimeRemaining){ // in jeopardy
            NSLog(@"in jeopardy");
            NSLog(@"%f", normalizedTimeRemaining);
            NSLog(@"%f", normalizedPushupsRemaining);
            return YES;
        } else {
            NSLog(@"not in jeopardy");
            return NO;
        }
    } else {
        return NO;
    }
}

@end
