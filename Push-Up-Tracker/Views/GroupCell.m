//
//  GroupCell.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/24/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "GroupCell.h"
#import "Goal.h"

@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.groupImageView.layer.masksToBounds = YES;
    self.groupImageView.layer.cornerRadius = self.groupImageView.bounds.size.width / 2;
    
    self.exclamationMarkImageView.alpha = 0;
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
    self.totalPushupsLabel.text = [@"Total Pushups: " stringByAppendingString:[group.totalPushups stringValue]];
}

- (void)setInJeopardy{
    self.exclamationMarkImageView.alpha = 1;
}

- (void)setGoalsActive:(NSNumber *)goalsActive{
    NSLog(@"set goals active");
    self.goalsActiveLabel.text = [@"Goals active: " stringByAppendingString:[goalsActive stringValue]];
}

@end
