//
//  EditGroupViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/4/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "EditGroupViewController.h"
#import "CEFPFFileObjectHelper.h"
#import "MBProgressHUD.h"

@interface EditGroupViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *groupPictureImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateButton;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITextField *joinCodeField;

@property (nonatomic) BOOL groupPictureChanged;

@end

@implementation EditGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.updateButton.enabled = NO;
    
    self.groupNameField.text = self.group.name;
    self.joinCodeField.text = self.group.code;
    self.groupPictureImageView.file = self.group[@"image"];
    [self.groupPictureImageView loadInBackground];
}

- (IBAction)onUpdatePressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(![self.joinCodeField.text isEqualToString:self.group.code]){
        PFQuery *groupQuery = [Group query];
        NSArray<NSString *> *keys = @[@"code"];
        [groupQuery selectKeys:keys];
        [groupQuery whereKey:@"code" equalTo:self.joinCodeField.text];
        
        // fetch data asynchronously (check again if group code exists already because it's possible someone made a group while we were choosing image)
        [groupQuery findObjectsInBackgroundWithBlock:^(NSArray<Group *> * _Nullable groups, NSError * _Nullable error) {
            if (groups) {
                NSLog(@"groups not null");
                // do something with the data fetched
                if(groups.count > 0){
                    // need to choose new code
                    [self codeTakenAlert];
                } else {
                    // save group with new metadata
                    if(![self.joinCodeField.text isEqualToString:self.group.code]){
                        self.group.code = self.joinCodeField.text;
                    }
                    if(![self.groupNameField.text isEqualToString:self.group.name]){
                        self.group.name = self.groupNameField.text;
                    }
                    if(self.groupPictureChanged){
                        self.group.image = [CEFPFFileObjectHelper getPFFileFromImage:[self resizeImage:self.groupPictureImageView.image withSize:CGSizeMake(100, 100)]];
                    }
                    
                    [self.group saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(succeeded){
                            NSLog(@"successfully updated ");
                        
                            [self.delegate didEditGroup:self.group];
                            
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } else {
        // save group with new metadata
        if(![self.groupNameField.text isEqualToString:self.group.name]){
            self.group.name = self.groupNameField.text;
        }
        if(self.groupPictureChanged){
            self.group.image = [CEFPFFileObjectHelper getPFFileFromImage:[self resizeImage:self.groupPictureImageView.image withSize:CGSizeMake(100, 100)]];
        }
        
        [self.group saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"successfully updated ");
                
                [self.delegate didEditGroup:self.group];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"fail");
                NSLog(error.description);
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (IBAction)onGroupPictureImageViewTapped:(id)sender {
    // choose image
    [self groupImageAlert];
}

- (IBAction)onBackdropTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onFieldEdited:(id)sender {
    if(self.groupNameField.text.length > 0 && self.joinCodeField.text.length > 0 && !([self.groupNameField.text isEqualToString:self.group.name] && [self.joinCodeField.text isEqualToString:self.group.code] && !self.groupPictureChanged)){
        self.updateButton.enabled = YES;
    } else {
        self.updateButton.enabled = NO;
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

    self.groupPictureImageView.image = editedImage;
    
    // Do something with the images (based on your use case)
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        self.groupPictureChanged = YES;
        if(self.groupNameField.text.length > 0 && self.joinCodeField.text.length > 0){
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
