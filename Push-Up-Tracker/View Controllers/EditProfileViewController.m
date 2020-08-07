//
//  EditProfileViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/6/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "EditProfileViewController.h"
#import <Parse/Parse.h>
#import "CEFPFFileObjectHelper.h"
#import "MBProgressHUD.h"

@interface EditProfileViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *updatedPasswordField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateButton;

@property (nonatomic) BOOL profilePictureChanged;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.updateButton.enabled = NO;
    
    self.usernameField.text = [PFUser currentUser].username;
    self.profilePictureImageView.file = [PFUser currentUser][@"profileImage"];
    [self.profilePictureImageView loadInBackground];
}

- (IBAction)onProfilePictureImageViewTapped:(id)sender {
    // choose image
    [self profilePictureImageAlert];
}

- (IBAction)onBackdropTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onFieldEdited:(id)sender {
    if(self.usernameField.text.length > 0 && (![self.usernameField.text isEqualToString:[PFUser currentUser].username] || self.profilePictureChanged || self.updatedPasswordField.text.length > 0)) {
        self.updateButton.enabled = YES;
    } else {
        self.updateButton.enabled = NO;
    }
}

- (IBAction)onUpdatePressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(![self.usernameField.text isEqualToString:[PFUser currentUser].username]){
        [PFUser currentUser].username = self.usernameField.text;
    }
    if(self.updatedPasswordField.text.length > 0){
        [PFUser currentUser].password = self.updatedPasswordField.text;
    }
    if(self.profilePictureChanged){
        [PFUser currentUser][@"profileImage"] = [CEFPFFileObjectHelper getPFFileFromImage:[self resizeImage:self.profilePictureImageView.image withSize:CGSizeMake(100, 100)]];
    }
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"successfully updated user");
        
            [self.delegate didEditUser];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"failed to update user");
            NSLog(error.description);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)profilePictureImageAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose A Profile Picture"
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

    self.profilePictureImageView.image = editedImage;
    
    // Do something with the images (based on your use case)
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        self.profilePictureChanged = YES;
        if(self.usernameField.text.length > 0){
            self.updateButton.enabled = YES;
        }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
