//
//  SetDetailsViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/30/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SetDetailsViewController : UIViewController
@property (strong, nonatomic) Set *set;
@end

NS_ASSUME_NONNULL_END
