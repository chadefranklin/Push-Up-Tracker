//
//  CEFDefaultHelper.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/12/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "CEFDefaultHelper.h"

@implementation CEFDefaultHelper

// if key doesn't exist, will return false
+ (NSInteger)getVoiceUserDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger voice = [defaults integerForKey:@"default_voice"];
    
    return voice;
}

+ (void)setVoiceUserDefault:(NSInteger)index{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:index forKey:@"default_voice"];
    [defaults synchronize];
}


+ (NSInteger)getPushupSpeedUserDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger pushupSpeed = [defaults integerForKey:@"default_pushup_speed"];
    
    return pushupSpeed;
}

+ (void)setPushupSpeedUserDefault:(NSInteger)index{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:index forKey:@"default_pushup_speed"];
    [defaults synchronize];
}

+ (BOOL)voiceUserDefaultExists{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"default_voice"]){
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)pushupSpeedUserDefaultExists{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"default_pushup_speed"]){
        return YES;
    } else {
        return NO;
    }
}

@end
