//
//  CaptureView.m
//  ImageComparison
//
//  Created by TRACER on 2019/11/22.
//  Copyright © 2019 TRACER. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/ios.h>

#import "CaptureView.h"

@interface CaptureView()<CvVideoCameraDelegate>

@property (strong, nonatomic)  UIImageView *CvImageV;

@property (nonatomic,retain) CvVideoCamera *videoCamera;

@end

@implementation CaptureView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self getImageFromVideo];
        
    }
    return self;
}

// MARK: - init
-(void)getImageFromVideo{

    self.CvImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    
    self.videoCamera = [[CvVideoCamera  alloc]initWithParentView:self.CvImageV];
    
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    
    // 设置分辨率
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetiFrame960x540;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.defaultFPS = 30;
    [self addSubview:self.CvImageV];
}

// MARK: - CvVideoCameraDelegate
- (void)processImage:(cv::Mat &)image{
    
    // 将Mat转换为Xcode的UIImageView显示
    UIImage *currentImage = MatToUIImage(image);
    
}

// MARK: - event and response
// 开启
- (void)start{
    [self.videoCamera start];
}

// 暂停
- (void)stop{
    [self.videoCamera stop];
}

@end
