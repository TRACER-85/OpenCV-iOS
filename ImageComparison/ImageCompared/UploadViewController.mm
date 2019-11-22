//
//  UploadViewController.m
//  ImageComparison
//
//  Created by TRACER on 2019/11/21.
//  Copyright © 2019 TRACER. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/ios.h>

#import "UploadViewController.h"
#import "Masonry.h"
#import "CaptureView.h"


@interface UploadViewController ()<CaptureViewDelegate>

/** 拍照 */
@property (nonatomic, strong) UIButton *takePhotoBtn;

@property (nonatomic, strong) CaptureView *captureView; //

/** opencv实时返回的图片 */
@property (nonatomic, strong) UIImage *photoImage;

@property (nonatomic, strong) UIImageView *imageV; //

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPageSubviews];
    
    // 开启
    [self.captureView start];
    
}

// MARK: - init
-(void)layoutPageSubviews{
    
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(130);
        make.width.mas_equalTo(200);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.takePhotoBtn];
    [self.takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-70);
        make.width.mas_equalTo(223);
        make.height.mas_equalTo(60);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.captureView];
}

// MARK: -  CaptureViewDelegate
- (void)captureWithImage:(UIImage *)image{
    self.photoImage = image;
}

// MARK: - 业务
// BGR转RGB
-(UIImage *)MatToUIImageWith:(cv::Mat &)mat{
    
    cv::Mat dst;
    cvtColor(mat, dst, CV_BGR2RGB);
    
    NSData *data = [NSData dataWithBytes:dst.data length:dst.elemSize() * dst.total()];
    CGColorSpaceRef colorspace;
    
    if (mat.elemSize() == 1) {
        colorspace = CGColorSpaceCreateDeviceGray();
        
    } else{
        
        colorspace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(dst.cols, dst.rows, 8, 8 *dst.elemSize(), dst.step[0], colorspace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorspace);
    return image;
}


// MARK: - event
-(void)takePhotoBtnClick{
    
    // TODO: 这里直接显示BGR，如需转换可调用MatToUIImageWith: 方法
    self.imageV.image = self.photoImage;
}

// MARK: - setter/getter
- (UIButton *)takePhotoBtn{
    
    if (!_takePhotoBtn) {
        _takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePhotoBtn setTitle:@"请拍照" forState:UIControlStateNormal];
        _takePhotoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _takePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_takePhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"top_fujin"] forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _takePhotoBtn.enabled = YES;
    }
    
    return _takePhotoBtn;
}

- (UIImageView *)imageV{
 
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    
    return _imageV;
}

- (CaptureView *)captureView{
 
    if (!_captureView) {
        _captureView = [[CaptureView alloc] initWithFrame:CGRectMake(10, 170, [UIScreen mainScreen].bounds.size.width - 20, 330)];
        _captureView.delegate = self;
    }
    
    return _captureView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
