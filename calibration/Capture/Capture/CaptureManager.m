//
//  CaptureManager.m
//  Capture
//
//  Created by Peyton Randolph on 8/13/15.
//  Copyright © 2015 peytn. All rights reserved.
//

#import "CaptureManager.h"

#import "RosyWriterCapturePipeline.h"

@interface CaptureManager () <RosyWriterCapturePipelineDelegate> {
    BOOL _allowedToUseGPU;
}

@end

@implementation CaptureManager

#pragma mark - RosyWriterCapturePipelineDelegate

- (void)capturePipeline:(RosyWriterCapturePipeline *)capturePipeline didStopRunningWithError:(NSError *)error
{
    [self.delegate captureManager:self didStopRunningWithError:error];
}

// Preview
- (void)capturePipeline:(RosyWriterCapturePipeline *)capturePipeline previewPixelBufferReadyForDisplay:(CVPixelBufferRef)previewPixelBuffer
{
    if (!_allowedToUseGPU)
        return;
    
    [self.delegate captureManager:self previewPixelBufferReadyForDisplay:previewPixelBuffer];
}

- (void)capturePipelineDidRunOutOfPreviewBuffers:(RosyWriterCapturePipeline *)capturePipeline
{
    NSLog(@"Capture pipeline ran out of preview buffers!");
}

// Recording
- (void)capturePipelineRecordingDidStart:(RosyWriterCapturePipeline *)capturePipeline
{
}

- (void)capturePipelineRecordingWillStop:(RosyWriterCapturePipeline *)capturePipeline
{
}

- (void)capturePipelineRecordingDidStop:(RosyWriterCapturePipeline *)capturePipeline
{
}

- (void)capturePipeline:(RosyWriterCapturePipeline *)capturePipeline recordingDidFailWithError:(NSError *)error
{
    [self.delegate captureManager:self didStopRunningWithError:error];
}

@end
