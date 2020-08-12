//
//  PushupSettingsViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/11/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "PushupSettingsViewController.h"
#import "CEFDefaultHelper.h"

@interface PushupSettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *pushupSpeedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *voiceControl;

@end

@implementation PushupSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([CEFDefaultHelper voiceUserDefaultExists]){
        self.voiceControl.selectedSegmentIndex = [CEFDefaultHelper getVoiceUserDefault];
    } else {
        self.voiceControl.selectedSegmentIndex = 0;
    }
    if([CEFDefaultHelper pushupSpeedUserDefaultExists]){
        self.pushupSpeedControl.selectedSegmentIndex = [CEFDefaultHelper getPushupSpeedUserDefault];
    } else {
        self.pushupSpeedControl.selectedSegmentIndex = 1;
    }
}

- (IBAction)onPushupSpeedChanged:(id)sender {
    [CEFDefaultHelper setPushupSpeedUserDefault:self.pushupSpeedControl.selectedSegmentIndex];
}

- (IBAction)onVoiceChanged:(id)sender {
    [CEFDefaultHelper setVoiceUserDefault:self.voiceControl.selectedSegmentIndex];
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
