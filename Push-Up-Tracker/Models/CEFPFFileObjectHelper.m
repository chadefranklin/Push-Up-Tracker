//
//  CEFPFFileObjectHelper.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/3/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "CEFPFFileObjectHelper.h"

@implementation CEFPFFileObjectHelper

+ (CEFPFFileObjectHelper *)sharedObject {
    static CEFPFFileObjectHelper *sharedClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    return sharedClass;
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (PFFileObject *)getPFFileFromVideoFileURL: (NSURL * _Nullable)path {
 
    // check if path is not nil
    if (!path) {
        return nil;
    }
    
    NSData *videoData = [NSData dataWithContentsOfURL:path];
    if (!videoData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"video.mov" data:videoData contentType:@"video/quicktime"];
}

@end
