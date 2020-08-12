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

- (IBAction)onDatePickerValueChanged:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)onAddPressed:(id)sender {
    if([self.deadlineDatePicker.date timeIntervalSinceDate:[NSDate now]] > 0){
        [self.delegate didAddGoal:[NSNumber numberWithInteger:[self.pushupAmountField.text integerValue]] withDeadline:self.deadlineDatePicker.date];
    } else {
        [self chooseFutureDateAlert];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseFutureDateAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect Date"
           message:@"Please choose a time in the future."
    preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
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
