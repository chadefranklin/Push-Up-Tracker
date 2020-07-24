//
//  AddGroupViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/23/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "AddGroupViewController.h"
#import <Parse/Parse.h>
#import "Group.h"

@interface AddGroupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *joinJoinCodeField;
@property (weak, nonatomic) IBOutlet UITextField *createGroupNameField;
@property (weak, nonatomic) IBOutlet UITextField *createJoinCodeField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation AddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.joinButton.enabled = NO;
    self.createButton.enabled = NO;
}

- (IBAction)onJoinPressed:(id)sender {
    
}

- (IBAction)onCreatePressed:(id)sender {
    PFQuery *groupQuery = [Group query];
    NSString *codeString = @"code";
    NSArray *keys = [NSArray array];
    keys = [keys arrayByAddingObject:codeString];
    [groupQuery selectKeys:keys];
    [groupQuery whereKey:codeString equalTo:self.createJoinCodeField.text];
    
    // fetch data asynchronously
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray<Group *> * _Nullable groups, NSError * _Nullable error) {
        if (groups) {
            NSLog(@"groups not null");
            // do something with the data fetched
            if(groups.count > 0){
                // need to choose new code
                [self codeTakenAlert];
            } else {
                // create group
                [Group createGroup:self.createGroupNameField.text withCode:self.createJoinCodeField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded){
                        NSLog(@"success");
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        NSLog(@"fail");
                        NSLog(error.description);
                    }
                }];
            }
        }
        else {
            // handle error
            NSLog(@"error checking groups' codes");
        }
    }];
}

- (IBAction)onJoinFieldEdited:(id)sender {
    if(self.joinJoinCodeField.text.length > 0){
        self.joinButton.enabled = YES;
    } else {
        self.joinButton.enabled = NO;
    }
}

- (IBAction)onCreateFieldEdited:(id)sender {
    if(self.createGroupNameField.text.length > 0 && self.createJoinCodeField.text.length > 0){
        self.createButton.enabled = YES;
    } else {
        self.createButton.enabled = NO;
    }
}

- (void)codeTakenAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Code Taken"
           message:@"Please choose a new group code."
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
