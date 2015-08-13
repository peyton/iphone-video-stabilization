//
//  ViewController.m
//  Capture
//
//  Created by Peyton Randolph on 8/8/15.
//  Copyright © 2015 peytn. All rights reserved.
//

#import "CaptureViewController.h"

@interface CaptureViewController ()

@property (nonatomic, weak) IBOutlet UIButton *captureButton;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *captureButtonBlurView;

@property (nonatomic, weak) IBOutlet UILabel *dimensionsLabel;
@property (nonatomic, weak) IBOutlet UILabel *fpsLabel;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *statsBlurView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
