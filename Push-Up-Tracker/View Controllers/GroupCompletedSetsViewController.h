//
//  GroupCompletedSetsViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupCompletedSetsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) Group *group;

- (void)profilePicturePressed:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
