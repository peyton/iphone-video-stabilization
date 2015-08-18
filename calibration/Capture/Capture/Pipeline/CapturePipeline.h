
 /*
     File: CapturePipeline.h
 Abstract: The class that creates and manages the AVCaptureSession
  Version: 2.1
 
Adapted from RosyWriterCapturePipeline.h
 
 */


@import AVFoundation;
@import UIKit;

@protocol CapturePipelineDelegate;

@interface CapturePipeline : NSObject 

- (void)setDelegate:(id<CapturePipelineDelegate>)delegate callbackQueue:(dispatch_queue_t)delegateCallbackQueue; // delegate is weak referenced

// These methods are synchronous
- (void)startRunning;
- (void)stopRunning;

// Must be running before starting recording
// These methods are asynchronous, see the recording delegate callbacks
- (void)startRecording;
- (void)stopRecording;

@property (assign) BOOL renderingEnabled; // When set to false the GPU will not be used after the setRenderingEnabled: call returns.

@property (assign) AVCaptureVideoOrientation recordingOrientation; // client can set the orientation for the recorded movie

- (CGAffineTransform)transformFromVideoBufferOrientationToOrientation:(AVCaptureVideoOrientation)orientation withAutoMirroring:(BOOL)mirroring; // only valid after startRunning has been called

// Stats
@property (assign, readonly) float videoFrameRate;
@property (assign, readonly) CMVideoDimensions videoDimensions;

@end

@protocol CapturePipelineDelegate <NSObject>
@required

- (void)capturePipeline:(CapturePipeline *)capturePipeline didStopRunningWithError:(NSError *)error;

// Preview
- (void)capturePipeline:(CapturePipeline *)capturePipeline previewPixelBufferReadyForDisplay:(CVPixelBufferRef)previewPixelBuffer;
- (void)capturePipelineDidRunOutOfPreviewBuffers:(CapturePipeline *)capturePipeline;

// Recording
- (void)capturePipelineRecordingDidStart:(CapturePipeline *)capturePipeline;
- (void)capturePipeline:(CapturePipeline *)capturePipeline recordingDidFailWithError:(NSError *)error; // Can happen at any point after a startRecording call, for example: startRecording->didFail (without a didStart), willStop->didFail (without a didStop)
- (void)capturePipelineRecordingWillStop:(CapturePipeline *)capturePipeline;
- (void)capturePipelineRecordingDidStop:(CapturePipeline *)capturePipeline;

@end
