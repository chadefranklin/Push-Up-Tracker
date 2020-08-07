//
//  AddGoalViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/6/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "AddGoalViewController.h"
#import "DateTools.h"
#import "Goal.h"

@interface AddGoalViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pushupAmountField;
@property (weak, nonatomic) IBOutlet UIDatePicker *deadlineDatePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation AddGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.deadlineDatePicker.minimumDate = [NSDate now];
    
    self.addButton.enabled = NO;
}

- (IBAction)onFieldEdited:(id)sender {
    if(self.pushupAmountField.text.length > 0){
        NSMutableCharacterSet *digitsAndDots = [NSMutableCharacterSet decimalDigitCharacterSet];
        [digitsAndDots addCharactersInString:@"."];
        NSCharacterSet *notDigitsNorDots = [digitsAndDots invertedSet];
        if ([self.pushupAmountField.text rangeOfCharacterFromSet:notDigitsNorDots].location == NSNotFound)
        {
            self.addButton.enabled = YES;
        } else {
            self.addButton.enabled = NO;
        }
    } else {
        self.addButton.enabled = NO;
    }
}

- (IBAction)onBackdropTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onAddPressed:(id)sender {
    [self.delegate didAddGoal:[NSNumber numberWithInteger:[self.pushupAmountField.text integerValue]] withDeadline:self.deadlineDatePicker.date];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
