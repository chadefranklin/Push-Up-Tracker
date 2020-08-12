//
//  GroupMemberCell.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/12/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "GroupMemberCell.h"

@implementation GroupMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMember:(PFUser *)member {
    _member = member;
    //self.groupImageView.file = group[@"image"];
    //[self.groupImageView loadInBackground];
    
    self.usernameLabel.text = member.username;
    self.profileImageView.file = member[@"profileImage"];
    [self.profileImageView loadInBackground];
}

@end
