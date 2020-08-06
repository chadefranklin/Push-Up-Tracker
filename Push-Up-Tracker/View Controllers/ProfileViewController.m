//
//  ProfileViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/16/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "CEFPFFileObjectHelper.h"
#import "ProfileCompletedSetsViewController.h"
#import "RankingSystem.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *maxPushupsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPushupsLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usernameLabel.text = [PFUser currentUser].username;
    self.profileImageView.file = PFUser.currentUser[@"profileImage"];
    [self.profileImageView loadInBackground];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.totalPushupsLabel.text = [@"Total Pushups: " stringByAppendingString:[PFUser.currentUser[@"totalPushups"] stringValue]];
    self.maxPushupsLabel.text = [@"Max Pushups: " stringByAppendingString:[PFUser.currentUser[@"maxPushups"] stringValue]];
    self.rankLabel.text = [RankingSystem getRankForMaxPushups:PFUser.currentUser[@"maxPushups"]];
}

- (IBAction)onLogOutPressed:(id)sender {
    NSLog(@"onLogOutPressed");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject.delegate;
            
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        sceneDelegate.window.rootViewController = loginViewController;
    }];
}

- (IBAction)onProfileImagePressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // ask whether to use camera or photo library
        [self profilePictureImageAlert];
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        //[self pickImage:NO];
        [self profilePictureImageAlert];
    }
}

- (void)profilePictureImageAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose A Profile Image"
           message:@"Please choose a photo location"
    preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // create an OK action
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self pickImage:YES];
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:cameraAction];
    }
    
    // create an OK action
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             [self pickImage:NO];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:photoLibraryAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
        NSLog(@"alert controller finished presenting");
    }];
}

- (void)pickImage:(BOOL)camera{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if (camera) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"imagePickerController");
    // Get the image captured by the UIImagePickerController
    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        PFUser.currentUser[@"profileImage"] = [CEFPFFileObjectHelper getPFFileFromImage:[self resizeImage:editedImage withSize:CGSizeMake(100, 100)]];
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
              self.profileImageView.file = PFUser.currentUser[@"profileImage"];
              [self.profileImageView loadInBackground];
            }
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"toProfileCompletedSetsSegue"]){
        ProfileCompletedSetsViewController *profileCompletedSetsViewController = (ProfileCompletedSetsViewController*)[segue destinationViewController];
        profileCompletedSetsViewController.user = [PFUser currentUser];
    }
}


@end
