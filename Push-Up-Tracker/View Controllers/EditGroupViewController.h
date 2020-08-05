//
//  EditGroupViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/4/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface EditGroupViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Group *group;

@end

NS_ASSUME_NONNULL_END