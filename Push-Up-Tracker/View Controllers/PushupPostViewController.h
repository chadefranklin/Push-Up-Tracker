//
//  PushupPostViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/3/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <AVFoundation/AVFoundation.h>
//#import <AVKit/AVKit.h>
//#import <AssetsLibrary/AssetsLibrary.h>

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

// Can delete if not storing videos to the photo library.  Delete the assetslibrary framework too requires this)
#import <AssetsLibrary/AssetsLibrary.h>

NS_ASSUME_NONNULL_BEGIN

@interface PushupPostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSNumber *pushupCount;

@end

NS_ASSUME_NONNULL_END
