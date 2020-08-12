//
//  CEFDateHelper.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/12/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "CEFDateHelper.h"

@implementation CEFDateHelper

+ (CEFDateHelper *)sharedObject {
    static CEFDateHelper *sharedClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    return sharedClass;
}

- (NSString *)formatDate:(NSDate *)date withDateFormat:(NSString *)dateFormat{
    if(!self.dateFormatter){
        self.dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    self.dateFormatter.dateFormat = dateFormat;
    // Configure output format
    //self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    //self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    return [self.dateFormatter stringFromDate:date];
}

@end
