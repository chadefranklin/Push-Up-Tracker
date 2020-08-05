//
//  OtherProfileViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface OtherProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
