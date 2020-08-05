//
//  SetCell.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/28/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "SetCell.h"
#import "DateTools.h"

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSet:(Set *)set {
    _set = set;
    //self.groupImageView.file = group[@"image"];
    //[self.groupImageView loadInBackground];
    
    self.usernameLabel.text = set.creator.username;
    self.imagePreviewImageView.file = set[@"image"];
    [self.imagePreviewImageView loadInBackground];
    self.profileImageView.file = set.creator[@"profileImage"];
    [self.profileImageView loadInBackground];
    
    self.pushupAmountLabel.text = [[set.pushupAmount stringValue] stringByAppendingString:@" Pushups"];
    
    self.timestampLabel.text = [set.createdAt timeAgoSinceNow];
}

- (IBAction)onProfileImagePressed:(id)sender {
    [self.groupCompletedSetsViewController profilePicturePressed:self.set.creator];
}


@end
