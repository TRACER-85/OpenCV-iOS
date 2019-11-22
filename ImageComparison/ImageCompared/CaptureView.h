//
//  CaptureView.h
//  ImageComparison
//
//  Created by TRACER on 2019/11/22.
//  Copyright © 2019 TRACER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaptureViewDelegate <NSObject>

@optional

/** 返回image */
-(void)captureWithImage:(UIImage *)image;

@end

@interface CaptureView : UIView

@property (nonatomic, weak) id <CaptureViewDelegate> delegate; //

// 摄像头
- (void)start;

- (void)stop;

@end

