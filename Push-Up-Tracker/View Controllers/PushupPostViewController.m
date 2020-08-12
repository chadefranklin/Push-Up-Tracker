//
//  PushupPostViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 8/3/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "PushupPostViewController.h"
#import "CEFFileHelper.h"
#import "Set.h"
#import "MBProgressHUD.h"

@interface PushupPostViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pushupCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

@property (nonatomic) AVPlayer *aVPlayer;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) BOOL waitingForPostResponse;

@property (nonatomic, nullable) NSNumber *latitude;
@property (nonatomic, nullable) NSNumber *longitude;

@end

@implementation PushupPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pushupCountLabel.text = [self.pushupCount stringValue];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    [self generateImagePreview];
}

- (void)generateImagePreview{
    NSString *outputPath = [CEFFileHelper.sharedObject outputPath];
    NSURL *outputURL = [CEFFileHelper.sharedObject outputURL];
    
    NSLog(outputURL.absoluteString);
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outputURL options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generateImg.appliesPreferredTrackTransform = YES;
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 65);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);

    UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
    
    self.previewImage.image = FrameImage;
}

- (IBAction)onPreviewPressed:(id)sender {
    // create a player view controller
        NSString *outputPath =  [CEFFileHelper.sharedObject getPushupSetOutputVideoPath];
        NSURL *outputURL = [CEFFileHelper.sharedObject getPushupSetOutputVideoPathURL];
        
        self.aVPlayer = [AVPlayer playerWithURL:outputURL];

        // create a player view controller
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        [self presentViewController:controller animated:YES completion:nil];
        controller.player = self.aVPlayer;
        [self.aVPlayer play];
}


- (IBAction)onPostPressed:(id)sender {
    NSLog(@"onPostPressed");
    
    if(self.waitingForPostResponse) return;
    
    self.waitingForPostResponse = YES;

    NSString *outputPath =  [CEFFileHelper.sharedObject getPushupSetOutputVideoPath];
    NSURL *outputURL = [CEFFileHelper.sharedObject getPushupSetOutputVideoPathURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [Set createSet:self.pushupCount withVideoURL:outputURL withImage:[self resizeImage:self.previewImage.image withSize:CGSizeMake(400, 400)] withLatitude:self.latitude withLongitude:self.longitude withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"successfully posted set");
            //[self dismissViewControllerAnimated: YES completion: nil];
            [self.navigationController popViewControllerAnimated:YES];
            //TODO: Maybe delete file here? Or just wait until next record?
        } else {
            NSLog(@"failed to post set");
            NSLog(error.description);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.waitingForPostResponse = NO;
    }];
}

- (IBAction)onPreviewImageButtonPressed:(id)sender {
    [self previewImageAlert];
}

- (void)previewImageAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Preview Image"
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

    self.previewImage.image = editedImage;
    
    // Do something with the images (based on your use case)
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        
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


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    self.latitude = [NSNumber numberWithFloat:newLocation.coordinate.latitude];
    self.longitude = [NSNumber numberWithFloat:newLocation.coordinate.longitude];
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(error.description);
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
