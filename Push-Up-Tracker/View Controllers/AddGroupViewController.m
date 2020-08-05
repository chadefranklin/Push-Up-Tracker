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
    PFQuery *groupQuery = [Group query];
    [groupQuery orderByDescending:@"createdAt"];
    NSArray<NSString *> *keys = @[@"code"];
    [groupQuery selectKeys:keys];
    [groupQuery whereKey:@"code" equalTo:self.joinJoinCodeField.text];
    
    // fetch data asynchronously
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray<Group *> * _Nullable groups, NSError * _Nullable error) {
        if (groups) {
            NSLog(@"groups not null");
            // do something with the data fetched
            if(groups.count > 0){
                // join group with index 0
                PFRelation *relation = [groups[0] relationForKey:@"members"];
                [relation addObject:[PFUser currentUser]];
                
                [groups[0] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded){
                        NSLog(@"successfully joined group");
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        NSLog(@"failed to join group");
                        NSLog(error.description);
                    }
                }];
            } else {
                // no group with that code
                [self noGroupFoundAlert];
            }
        }
        else {
            // handle error
            NSLog(@"error checking groups' codes");
        }
    }];
}

- (IBAction)onCreatePressed:(id)sender {
    PFQuery *groupQuery = [Group query];
    NSArray<NSString *> *keys = @[@"code"];
    [groupQuery selectKeys:keys];
    [groupQuery whereKey:@"code" equalTo:self.createJoinCodeField.text];
    
    
    // fetch data asynchronously (check if group code exists already)
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray<Group *> * _Nullable groups, NSError * _Nullable error) {
        if (groups) {
            NSLog(@"groups not null");
            // do something with the data fetched
            if(groups.count > 0){
                // need to choose new code
                [self codeTakenAlert];
            } else {
                // choose image
                [self groupImageAlert];
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

- (IBAction)onBackdropTapped:(id)sender {
    [self.view endEditing:YES];
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

- (void)noGroupFoundAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Group Found"
           message:@"Please double check the group code."
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



- (void)groupImageAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose A Group Image"
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
        PFQuery *groupQuery = [Group query];
        NSArray<NSString *> *keys = @[@"code"];
        [groupQuery selectKeys:keys];
        [groupQuery whereKey:@"code" equalTo:self.createJoinCodeField.text];
        
        // fetch data asynchronously (check again if group code exists already because it's possible someone made a group while we were choosing image)
        [groupQuery findObjectsInBackgroundWithBlock:^(NSArray<Group *> * _Nullable groups, NSError * _Nullable error) {
            if (groups) {
                NSLog(@"groups not null");
                // do something with the data fetched
                if(groups.count > 0){
                    // need to choose new code
                    [self codeTakenAlert];
                } else {
                    // create group
                    [Group createGroup:self.createGroupNameField.text withCode:self.createJoinCodeField.text withImage:[self resizeImage:editedImage withSize:CGSizeMake(100, 100)] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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
