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

@end

@implementation CaptureManager

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
