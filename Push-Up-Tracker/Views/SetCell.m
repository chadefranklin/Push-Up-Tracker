//
//  SetCell.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/28/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "SetCell.h"

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
    //self.imagePreviewImageView.image = set.image;
    self.imagePreviewImageView.file = set[@"image"];
    [self.imagePreviewImageView loadInBackground];
}

@end
