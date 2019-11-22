//
//  SimilarlyViewController.m
//  ImageComparison
//
//  Created by TRACER on 2019/11/22.
//  Copyright © 2019 TRACER. All rights reserved.
//

#import "SimilarlyViewController.h"

#import "ImageCompared.h"
#import "Masonry.h"


@interface SimilarlyViewController ()

@property (nonatomic, strong) ImageCompared *similarly; //

@property (nonatomic, strong) UIImageView *imageV; //

@end

@implementation SimilarlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPageSubviews];
    
    
    // 调起相机获取实时照片参考UploadViewController文件，这里只用静态图做举例;
    
    UIImage *resultImage = [self.similarly similarlyMatchWithBox:[UIImage imageNamed:@"kaiguan"] andSence:[UIImage imageNamed:@"kaiguan"]];
    
    self.imageV.image = resultImage;
}

-(void)layoutPageSubviews{
    
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(380);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
}

- (ImageCompared *)similarly{
 
    if (!_similarly) {
        _similarly = [[ImageCompared alloc] init];
    }
    
    return _similarly;
}

- (UIImageView *)imageV{
 
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    
    return _imageV;
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
