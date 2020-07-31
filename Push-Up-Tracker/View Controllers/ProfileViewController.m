//
//  ProfileViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/16/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usernameLabel.text = [PFUser currentUser].username;
}

- (IBAction)onLogOutPressed:(id)sender {
    NSLog(@"onLogOutPressed");
// Does nothing when started application with persistent login
//    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
//        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
//    }];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject.delegate;
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
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
