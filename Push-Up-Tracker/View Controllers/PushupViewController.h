//
//  PushupViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/23/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

// Can delete if not storing videos to the photo library.  Delete the assetslibrary framework too requires this)
#import <AssetsLibrary/AssetsLibrary.h>

//#define CAPTURE_FRAMES_PER_SECOND        20

NS_ASSUME_NONNULL_BEGIN

@interface PushupViewController : UIViewController <AVCaptureFileOutputRecordingDelegate>

@end

NS_ASSUME_NONNULL_END
