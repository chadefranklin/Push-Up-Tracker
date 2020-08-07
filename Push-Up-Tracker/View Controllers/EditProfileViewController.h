//
//  EditProfileViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/6/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol EditProfileViewControllerDelegate

- (void)didEditUser;

@end

@interface EditProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<EditProfileViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
