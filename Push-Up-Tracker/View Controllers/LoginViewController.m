//
//  LoginViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/16/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "CEFPFFileObjectHelper.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signUpButton.enabled = NO;
    self.logInButton.enabled = NO;
}

- (IBAction)onSignUpPressed:(id)sender {
    [self.view endEditing:YES];
    [self profilePictureImageAlert];
}

- (IBAction)onLogInPressed:(id)sender {
    [self.view endEditing:YES];
    [self loginUser];
}

- (IBAction)onFieldEdited:(id)sender {
    if(self.usernameField.text.length > 0 && self.passwordField.text.length > 0){
        self.signUpButton.enabled = YES;
        self.logInButton.enabled = YES;
    } else {
        self.signUpButton.enabled = NO;
        self.logInButton.enabled = NO;
    }
}

- (void)registerUser:(UIImage*)profileImage {
    NSLog(@"register user");
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser[@"totalPushups"] = @(0);
    newUser[@"maxPushups"] = @(0);
    newUser[@"profileImage"] = [CEFPFFileObjectHelper getPFFileFromImage:profileImage];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        
            NSLog(@"%d", error.code);
            switch(error.code){
                case 202:
                    [self usernameTakenAlert];
                    break;
               default:
                    break;
            }
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
            NSLog(@"%d", error.code);
            switch(error.code){
                case 101:
                    [self invalidUserPassAlert];
                    break;
               default:
                    break;
            }
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
        [self registerUser:[self resizeImage:editedImage withSize:CGSizeMake(100, 100)]];
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

- (IBAction)onBackdropTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)invalidUserPassAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Username / Password"
           message:@"Please double check your input."
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

- (void)usernameTakenAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Username Taken"
           message:@"Please choose a different username."
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
