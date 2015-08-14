//
//  CaptureManager.h
//  Capture
//
//  Created by Peyton Randolph on 8/13/15.
//  Copyright © 2015 peytn. All rights reserved.
//

@import AVFoundation;
@import CoreMedia;
@import CoreVideo;

@protocol CaptureManagerDelegate;

@interface CaptureManager : NSObject

@property (nonatomic, weak) id<CaptureManagerDelegate> delegate;

@end

@protocol CaptureManagerDelegate <NSObject>

- (void)captureManager:(CaptureManager *)captureManager previewPixelBufferReadyForDisplay:(CVPixelBufferRef)previewPixelBuffer;

- (void)captureManager:(CaptureManager *)captureManager didStopRunningWithError:(NSError *)error;
- (void)captureManager:(CaptureManager *)captureManager didFailWithError:(NSError *)error;

@end
