//
//  SetCell.h
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/28/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set.h"
#import "GroupCompletedSetsViewController.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushupAmountLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imagePreviewImageView;


@property (strong, nonatomic) Set *set;

@property (weak, nonatomic) GroupCompletedSetsViewController *groupCompletedSetsViewController;

@end

NS_ASSUME_NONNULL_END
