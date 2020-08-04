//
//  CEFFileHelper.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/3/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "CEFFileHelper.h"

@implementation CEFFileHelper

+ (CEFFileHelper *)sharedObject {
    static CEFFileHelper *sharedClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    return sharedClass;
}

- (NSString *)getPushupSetOutputVideoPath {
    if(!self.outputPath || [self.outputPath isEqualToString:@""]){
        self.outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    }
    return self.outputPath;
}

- (NSURL *)getPushupSetOutputVideoPathURL {
    if(!self.outputURL || [[self.outputURL absoluteString] isEqualToString:@""]){
        self.outputURL = [[NSURL alloc] initFileURLWithPath:[self getPushupSetOutputVideoPath]];
    }
    return self.outputURL;
}

@end
