//
//  CaptureManager.m
//  Capture
//
//  Created by Peyton Randolph on 8/13/15.
//  Copyright © 2015 peytn. All rights reserved.
//

#import "CaptureManager.h"

#import "CapturePipeline.h"

@interface CaptureManager () <CapturePipelineDelegate> {
    BOOL _allowedToUseGPU;
}

@property (nonatomic, strong) CapturePipeline *capturePipeline;

@end

@implementation CaptureManager

- (instancetype)init;
{
    if (!(self = [super init]))
        return nil;
    
    
    
    return self;
}

- (BOOL)_commonInit;
{
    self.capturePipeline = [[CapturePipeline alloc] init];
    [self.capturePipeline setDelegate:self callbackQueue:dispatch_get_main_queue()];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    _allowedToUseGPU = [UIApplication sharedApplication].applicationState != UIApplicationStateBackground;
    self.capturePipeline.renderingEnabled = _allowedToUseGPU;
    
    return YES;
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

#pragma mark - Lifecycle

- (void)applicationDidEnterBackground:(NSNotification *)note;
{
    _allowedToUseGPU = NO;
    self.capturePipeline.renderingEnabled = NO;
    [self.capturePipeline stopRecording]; // no-op if we aren't recording
}

- (void)applicationWillEnterForeground:(NSNotification *)note;
{
    _allowedToUseGPU = YES;
    self.capturePipeline.renderingEnabled = YES;
}

#pragma mark - RosyWriterCapturePipelineDelegate

- (void)capturePipeline:(CapturePipeline *)capturePipeline didStopRunningWithError:(NSError *)error
{
    [self.delegate captureManager:self didStopRunningWithError:error];
}

// Preview
- (void)capturePipeline:(CapturePipeline *)capturePipeline previewPixelBufferReadyForDisplay:(CVPixelBufferRef)previewPixelBuffer
{
    if (!_allowedToUseGPU)
        return;
    
    [self.delegate captureManager:self previewPixelBufferReadyForDisplay:previewPixelBuffer];
}

- (void)capturePipelineDidRunOutOfPreviewBuffers:(CapturePipeline *)capturePipeline
{
    NSLog(@"Capture pipeline ran out of preview buffers!");
}

// Recording
- (void)capturePipelineRecordingDidStart:(CapturePipeline *)capturePipeline
{
}

- (void)capturePipelineRecordingWillStop:(CapturePipeline *)capturePipeline
{
}

- (void)capturePipelineRecordingDidStop:(CapturePipeline *)capturePipeline
{
}

- (void)capturePipeline:(CapturePipeline *)capturePipeline recordingDidFailWithError:(NSError *)error
{
    [self.delegate captureManager:self didStopRunningWithError:error];
}

@end
