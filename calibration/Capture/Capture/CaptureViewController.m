//
//  ViewController.m
//  Capture
//
//  Created by Peyton Randolph on 8/8/15.
//  Copyright © 2015 peytn. All rights reserved.
//

#import "CaptureViewController.h"

@import CoreMedia;
@import CoreVideo;

static const NSTimeInterval kUIFadeDuration = 0.3; // seconds

typedef NS_ENUM(NSInteger, CaptureState) {
    kCaptureStateReady,
    kCaptureStateCapturing,
    kCaptureStateSaving,
};

@interface CaptureViewController ()

@property (nonatomic, weak) IBOutlet UIButton *captureButton;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *captureButtonBlurView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *captureButtonSpinner;

@property (nonatomic, weak) IBOutlet UILabel *dimensionsLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UILabel *fpsLabel;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *statsBlurView;
@property (nonatomic, weak) IBOutlet UILabel *uuidLabel;

@property (nonatomic, assign) CaptureState state;

@end

@implementation CaptureViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    return [self _initCommon];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    return [self _initCommon];
}

- (instancetype)_initCommon
{
    self.state = kCaptureStateReady;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _configureInitialUI];
}

#pragma mark - User interface

- (void)_configureInitialUI;
{
    assert(self.isViewLoaded);
    [self _transitionUIToReadyState];
    
    // Hide elements left visible in storyboard for convenience.
    self.durationLabel.alpha = 0;
    self.uuidLabel.alpha = 0;
}

- (void)_dimensionsLabel:(CMVideoDimensions)dimensions;
{
    NSString *dimensionsString = [NSString stringWithFormat:@"%d\u00D7%d", (int)dimensions.width, (int)dimensions.height];
    self.dimensionsLabel.text = dimensionsString;
}

- (void)_updateDurationLabel:(NSTimeInterval)duration;
{
    NSString *durationString = [NSString stringWithFormat:@"%01.1fs", duration];
    self.durationLabel.text = durationString;
}

- (void)_updateFPSLabel:(float)fps;
{
    NSString *fpsString = [NSString stringWithFormat:@"%01.1ffps", fps];
    self.fpsLabel.text = fpsString;
}

- (void)_updateUUIDLabel:(NSUUID *)uuid;
{
    if (!uuid) {
        self.uuidLabel.text = @"Nil UUID";
        return;
    }
    
    NSString *firstEightBytesString = [[uuid.UUIDString substringToIndex:8] uppercaseString];
    self.uuidLabel.text = firstEightBytesString;
}

- (void)_showError:(NSError *)error;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedFailureReason preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)_captureButtonPressed:(id)sender;
{
    assert(sender == self.captureButton);
    
    switch (self.state) {
        case kCaptureStateSaving:
            [self _throwUnavailableInCurrentState];
            break;
        case kCaptureStateCapturing: {
            [self _transitionToState:kCaptureStateSaving];
            
            // Mock transition for testing
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self _transitionToState:kCaptureStateReady];
            });
            break;
        }
        case kCaptureStateReady:
            [self _transitionToState:kCaptureStateCapturing];
            
            break;
    }
}

#pragma mark - State

- (BOOL)_transitionToState:(CaptureState)state;
{
    if (state == self.state)
        return NO;
    
    if (![self _canTransitionToState:state fromState:self.state])
        return NO;
    
    switch (self.state) {
    case kCaptureStateReady:
        [self _transitionFromReadyState];
        break;
    case kCaptureStateCapturing:
        [self _transitionFromCapturingState];
        break;
    case kCaptureStateSaving:
        [self _transitionFromSavingState];
        break;
    }
    
    self.state = state;
    
    switch (self.state) {
    case kCaptureStateReady:
        [self _transitionToReadyState];
        break;
    case kCaptureStateCapturing:
        [self _transitionToCapturingState];
        break;
    case kCaptureStateSaving:
        [self _transitionToSavingState];
        break;
    }
    
    return YES;
}

- (void)_transitionToReadyState;
{
    [self _transitionUIAnimation:^{
        [self _transitionUIToReadyState];
    }];
}

- (void)_transitionFromReadyState;
{
    [self _transitionUIAnimation:^{
        [self _transitionUIFromReadyState];
    }];
}

- (void)_transitionToCapturingState;
{
    [self _transitionUIAnimation:^{
        [self _transitionUIToCapturingState];
    }];
}

- (void)_transitionFromCapturingState;
{
    [self _transitionUIAnimation:^{
        [self _transitionUIFromCapturingState];
    }];
}

- (void)_transitionToSavingState;
{
    [self _transitionUIAnimation:^{
        [self _transitionUIToSavingState];
    }];
}

- (void)_transitionFromSavingState;
{
    [self _transitionUIFromSavingState];
}

- (void)_transitionUIAnimation:(void(^)())animationBlock;
{
    if (!animationBlock)
        return;
    
    [UIView animateWithDuration:kUIFadeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:animationBlock completion:nil];
}

#pragma mark State, user interface

- (void)_transitionUIToReadyState;
{
    self.captureButton.enabled = YES;
    [self.captureButton setTitle:@"Capture" forState:UIControlStateNormal];
    
    self.captureButtonBlurView.contentView.backgroundColor = _greenBlurBackgroundColor();
}

- (void)_transitionUIFromReadyState;
{
    
}

- (void)_transitionUIToCapturingState;
{
    self.captureButton.enabled = YES;
    [self.captureButton setTitle:@"Finish" forState:UIControlStateNormal];
    
    self.captureButtonBlurView.contentView.backgroundColor = _redBlurBackgroundColor();
    
    [self _updateDurationLabel:0];
    [self _updateUUIDLabel:nil];
    self.durationLabel.alpha = 1;
    self.uuidLabel.alpha = 1;
}

- (void)_transitionUIFromCapturingState;
{
}

- (void)_transitionUIToSavingState;
{
    self.captureButton.enabled = NO;
    [self.captureButton setTitle:@"Saving\u2026" forState:UIControlStateNormal];
    
    self.captureButtonBlurView.contentView.backgroundColor = [UIColor clearColor];
    
    [self.captureButtonSpinner startAnimating];
}

- (void)_transitionUIFromSavingState;
{
    self.durationLabel.alpha = 0;
    self.uuidLabel.alpha = 0;
    [self.captureButtonSpinner stopAnimating];
}

#pragma mark State, defining transitions

- (BOOL)_canTransitionToState:(CaptureState)toState fromState:(CaptureState)fromState;
{
    switch (fromState) {
    case kCaptureStateReady:
        return [self _canTransitionFromReadyToState:toState];
    case kCaptureStateCapturing:
        return [self _canTransitionFromCapturingToState:toState];
    case kCaptureStateSaving:
        return [self _canTransitionFromSavingToState:toState];
    }
}

- (BOOL)_canTransitionFromReadyToState:(CaptureState)toState;
{
    return toState == kCaptureStateCapturing;
}

- (BOOL)_canTransitionFromCapturingToState:(CaptureState)toState;
{
    return toState == kCaptureStateSaving;
}

- (BOOL)_canTransitionFromSavingToState:(CaptureState)toState;
{
    return toState == kCaptureStateReady;
}

#pragma mark State, utility

static inline NSString *_CaptureStateToString(CaptureState state) {
    switch (state) {
    case kCaptureStateReady:
        return NSLocalizedString(@"Ready", nil);
    case kCaptureStateCapturing:
        return NSLocalizedString(@"Capturing", nil);
    case kCaptureStateSaving:
        return NSLocalizedString(@"Saving", nil);
    }
}

- (void)_throwUnavailableInCurrentState;
{
    NSString *reasonFormat = NSLocalizedString(@"Unavailable in current state (%@)", nil);
    NSString *reason = [NSString stringWithFormat:reasonFormat, _CaptureStateToString(self.state)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

#pragma mark - Constants

static inline UIColor *_greenBlurBackgroundColor()
{
    return [UIColor colorWithRed:.3 green:.9 blue:.5 alpha:.3];
}

static inline UIColor *_redBlurBackgroundColor()
{
    return [UIColor colorWithRed:.9 green:.3 blue:.5 alpha:.3];
}

@end
