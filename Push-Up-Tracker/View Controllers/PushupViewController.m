//
//  PushupViewController.m
//  Push-Up-Tracker
//
//  Created by chadfranklin on 7/23/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "PushupViewController.h"
#import "CEFFileHelper.h"
#import "PushupPostViewController.h"
#import "CEFDefaultHelper.h"

@interface PushupViewController () <AVCaptureFileOutputRecordingDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pushupImageView;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *pushupCountLabel;
@property (nonatomic) AVCaptureSession *captureSession;
//@property (nonatomic) AVCapturePhotoOutput *stillImageOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVPlayer *aVPlayer;
@property (nonatomic) AVCaptureDevice *cameraDevice;
@property (nonatomic) BOOL canStartSession;

@property (nonatomic) AVAudioPlayer *audioPlayer;

@property (nonatomic) BOOL sessionInProgress;
@property (nonatomic) NSTimer *pushupTimer;
@property (nonatomic) int pushupTimerTickCounter;
@property (nonatomic) double pushupTimerInterval;
@property (nonatomic) BOOL femaleVoice;

@end

@implementation PushupViewController

- (void)viewDidLoad {
    NSLog(@"P viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setSettings{
    if([CEFDefaultHelper voiceUserDefaultExists]){
        if([CEFDefaultHelper getVoiceUserDefault] == 1){
            self.femaleVoice = YES;
        } else {
            self.femaleVoice = NO;
        }
    } else {
        self.femaleVoice = NO;
    }
    if([CEFDefaultHelper pushupSpeedUserDefaultExists]){
        switch([CEFDefaultHelper getPushupSpeedUserDefault]){
            case 0:
                self.pushupTimerInterval = PUSHUP_SPEED_SLOW;
                break;
            case 1:
                self.pushupTimerInterval = PUSHUP_SPEED_MEDIUM;
                break;
            case 2:
                self.pushupTimerInterval = PUSHUP_SPEED_FAST;
                break;
           default:
                break;
        }
    } else {
        self.pushupTimerInterval = PUSHUP_SPEED_MEDIUM;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"P viewDidAppear");
    [super viewDidAppear:animated];
    
    
    // Setup camera here...
    self.captureSession = [AVCaptureSession new];
    
    self.captureSession.sessionPreset = AVCaptureSessionPreset640x480; //
    
    //AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.cameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    NSError *error;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.cameraDevice error:&error];
    
    if ([self.captureSession canAddInput:cameraDeviceInput] && !error) {
        [self.captureSession addInput:cameraDeviceInput];
        [self setupLivePreview];
    } else {
        NSLog(@"SOMETHING WENT WRONG!");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"P viewWillAppear");
    [super viewWillAppear:animated];
    
    [self resetViewController];
}

- (void)resetViewController{
    self.canStartSession = NO;
    self.sessionInProgress = NO;
    self.pushupTimerTickCounter = 0;
    [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor systemGreenColor]];
    self.pushupCountLabel.text = @"";
    self.settingsButton.enabled = YES;
    
    [self setSettings];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.captureSession stopRunning];
}

- (void)setupLivePreview {
    self.movieFileOutput = [AVCaptureMovieFileOutput new];
    //int32_t preferredTimeScale = 5; // Frames per second
    //CMTime maxDuration = CMTimeMakeWithSeconds(5000, preferredTimeScale);
    //self.movieFileOutput.maxRecordedDuration = maxDuration;
    if([self.captureSession canAddOutput:self.movieFileOutput]){
        [self.captureSession addOutput:self.movieFileOutput];
    }
    
    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    if (self.videoPreviewLayer) {
        
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self.previewView.layer addSublayer:self.videoPreviewLayer];
        
        dispatch_queue_t globalQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(globalQueue, ^{
            [self.captureSession startRunning];
            
            NSError *error;
            [self.cameraDevice lockForConfiguration:&error];
            if(!error){
                [self.captureSession beginConfiguration];
                
                self.cameraDevice.activeVideoMinFrameDuration = CMTimeMake(1, 10);
                self.cameraDevice.activeVideoMaxFrameDuration = CMTimeMake(1, 10);
                
                [self.captureSession commitConfiguration];
            }
            [self.cameraDevice unlockForConfiguration];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.videoPreviewLayer.frame = self.previewView.bounds;
                self.canStartSession = YES;
            });
        });
    }
}

- (void)startRecording{
    if(!self.canStartSession) return;
    
    self.settingsButton.enabled = NO;
    
    //Create temporary URL to record to
    NSString *outputPath =  [CEFFileHelper.sharedObject getPushupSetOutputVideoPath];
    NSURL *outputURL = [CEFFileHelper.sharedObject getPushupSetOutputVideoPathURL];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
        {
            //Error - handle if requried
            NSLog(@"error deleting previous file");
        }
    }
    //Start recording
    [self.movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
}

- (void)stopRecording{
    [self.movieFileOutput stopRecording];
}



- (IBAction)onStartStopPressed:(id)sender {
    NSLog(@"buttonPress");
    
    if(!self.sessionInProgress){
        [self startRecording];
    } else {
        self.sessionInProgress = NO;
        
        [self.pushupTimer invalidate];
        self.pushupTimer = nil;
        
        [self stopRecording];
    }
}

- (void)onPushupTimer {
   // Add code to be run periodically
    self.pushupTimerTickCounter++;
    NSLog(@"%d", self.pushupTimerTickCounter / 2);
    self.pushupCountLabel.text = [NSString stringWithFormat:@"%i", self.pushupTimerTickCounter / 2];
    
    if(self.pushupTimerTickCounter % 2 == 0){
        self.pushupImageView.image = [UIImage imageNamed:@"pushupUpImage"]; // up
        
        NSString *soundFilePath = nil;
        if(self.femaleVoice){
            soundFilePath = [[NSBundle mainBundle] pathForResource:@"Salli-Up" ofType:@"wav"];
        } else {
            soundFilePath = [[NSBundle mainBundle] pathForResource:@"Joey-Up" ofType:@"wav"];
        }

        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];

        NSError *error;

        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                                       error:&error];
        [self.audioPlayer play];
    } else {
        self.pushupImageView.image = [UIImage imageNamed:@"pushupDownImage"]; // down
        
        NSString *soundFilePath = nil;
        if(self.femaleVoice){
            soundFilePath = [[NSBundle mainBundle] pathForResource:@"Salli-Down" ofType:@"wav"];
        } else {
            soundFilePath = [[NSBundle mainBundle] pathForResource:@"Joey-Down" ofType:@"wav"];
        }

        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];

        NSError *error;

        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                                       error:&error];
        [self.audioPlayer play];
    }
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray*)connections {
    NSLog(@"Started Recording");
    
    self.sessionInProgress = YES;
    
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    self.pushupCountLabel.text = @"0";
    [UIView animateWithDuration:0.4 animations:^{
        self.startStopButton.backgroundColor = [UIColor systemRedColor];
    }];
    
    self.pushupTimer = [NSTimer scheduledTimerWithTimeInterval:self.pushupTimerInterval target:self selector:@selector(onPushupTimer) userInfo:nil repeats:true];
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray*)connections error:(NSError *)error {
    NSLog(@"Finished Recording");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
        /*
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
            {
                if (error)
                {

                }
            }];
        }

        [library release];
        */
        
        [self performSegueWithIdentifier:@"toPushupPostSegue" sender:nil];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toPushupPostSegue"]) {
        PushupPostViewController *pushupPostViewController = [segue destinationViewController];
        pushupPostViewController.pushupCount = @(self.pushupTimerTickCounter / 2);
    } else if ([segue.identifier isEqualToString:@"toPushupSettingsSegue"]) {
        
    }
}


@end
