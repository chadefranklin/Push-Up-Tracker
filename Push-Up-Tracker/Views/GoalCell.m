//
//  GoalCell.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/5/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "GoalCell.h"
#import "DateTools.h"
#import "CEFDateHelper.h"

@implementation GoalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoal:(Goal *)goal {
    _goal = goal;
    
    if([goal.pushupAmount intValue] > [goal.pushupTarget intValue]){
        self.deadlineLabel.text = @"Completed";
        self.goalProgressBar.barColor = [UIColor systemGreenColor];
    } else {
        //if([[NSDate now] timeIntervalSinceDate:goal.deadline] > 0 ) {
        if([goal.deadline timeIntervalSinceDate:[NSDate now]] > 0) {
            self.deadlineLabel.text = [self timeUntilDate:goal.deadline];
            
            [self checkIfInJeopardy];
        } else {
            //self.deadlineLabel.text = @"Time Expired";
            self.deadlineLabel.text = [@"Expired: " stringByAppendingString:[CEFDateHelper.sharedObject formatDate:goal.deadline withDateFormat:@"MM/dd/yyyy HH:mm"]];
            self.goalProgressBar.barColor = [UIColor systemRedColor];
        }
    }
    //self.goalProgressLabel.text = [[[goal.pushupAmount stringValue] stringByAppendingString:@" / "] stringByAppendingString:[goal.pushupTarget stringValue]];
    self.goalProgressLabel.text = [[[[goal.pushupAmount stringValue] stringByAppendingString:@" of "] stringByAppendingString:[goal.pushupTarget stringValue]] stringByAppendingString:@" Pushups Completed"];
    self.goalProgressBar.progressValue = ([goal.pushupAmount floatValue] / [goal.pushupTarget floatValue]) * 100;
}

-(NSString*)timeUntilDate:(NSDate *)date {
    NSMutableString *timeRemaining = [NSMutableString string];
    NSDate *now = [NSDate now];
    //int seconds = [now timeIntervalSinceDate:date];
    int seconds = [date timeIntervalSinceDate:now];
    NSLog(@"%d", seconds);
    
    int days = 0;
    int hours = 0;
    int minutes = 0;
    if(seconds > 60){
        if(seconds > 86400){
            days = seconds / 86400;
            seconds -= days * 86400;
            
            [timeRemaining appendString:[NSString stringWithFormat:@"%dd ", days]];
        }
        if(seconds > 3600){
            hours = seconds / 3600;
            seconds -= hours * 3600;
            
            [timeRemaining appendString:[NSString stringWithFormat:@"%dh ", hours]];
        }
        minutes = seconds / 60;
        seconds -= minutes * 60;
        
        [timeRemaining appendString:[NSString stringWithFormat:@"%dm ", minutes]];
    } else {
        [timeRemaining appendString:[NSString stringWithFormat:@"%ds ", seconds]];
    }
    
    
    
    [timeRemaining appendString:@"remaining"];

    return timeRemaining;
}

- (void)checkIfInJeopardy{
    NSDate *now = [NSDate now];
    int initialSeconds = [self.goal.deadline timeIntervalSinceDate:self.goal.createdAt];
    int remainingSeconds = initialSeconds - [now timeIntervalSinceDate:self.goal.createdAt];
    
    float normalizedTimeRemaining = remainingSeconds / (float)initialSeconds;
    float normalizedPushupsRemaining = ([self.goal.pushupTarget floatValue] - [self.goal.pushupAmount floatValue]) / [self.goal.pushupTarget floatValue];
    
    if(remainingSeconds < initialSeconds / 2){
        if(normalizedPushupsRemaining > normalizedTimeRemaining){ // in jeopardy
            NSLog(@"in jeopardy");
            NSLog(@"%f", normalizedTimeRemaining);
            NSLog(@"%f", normalizedPushupsRemaining);
            self.goalProgressBar.barColor = [UIColor systemRedColor];
        } else {
            self.goalProgressBar.barColor = [UIColor systemGreenColor];
        }
    } else {
        self.goalProgressBar.barColor = [UIColor systemGreenColor];
    }
}




@end
