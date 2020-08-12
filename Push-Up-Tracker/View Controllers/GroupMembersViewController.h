//
//  GroupMembersViewController.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/12/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupMembersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Group *group;

@end

NS_ASSUME_NONNULL_END
