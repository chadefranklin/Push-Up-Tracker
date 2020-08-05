//
//  GroupCell.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/24/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.groupImageView.layer.masksToBounds = YES;
    self.groupImageView.layer.cornerRadius = self.groupImageView.bounds.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGroup:(Group *)group {
    _group = group;
    self.groupImageView.file = group[@"image"];
    [self.groupImageView loadInBackground];
    
    self.groupNameLabel.text = group.name;
}

@end
