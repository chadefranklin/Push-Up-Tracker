//
//  AddGroupViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/23/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddGroupViewControllerDelegate

- (void)didAddGroup;

@end

@interface AddGroupViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<AddGroupViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
