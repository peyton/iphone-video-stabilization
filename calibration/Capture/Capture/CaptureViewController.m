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

@interface CaptureViewController ()

@property (nonatomic, weak) IBOutlet UIButton *captureButton;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *captureButtonBlurView;

@property (nonatomic, weak) IBOutlet UILabel *dimensionsLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UILabel *fpsLabel;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *statsBlurView;
@property (nonatomic, weak) IBOutlet UILabel *uuidLabel;

@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User interface

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

@end
