//
//  ImageCompared.m
//  ImageComparison
//
//  Created by TRACER on 2019/11/21.
//  Copyright © 2019 TRACER. All rights reserved.
//

#import <opencv2/opencv.hpp>
#include "opencv2/core/core.hpp"
#import <opencv2/imgcodecs/ios.h>

#include <iostream>
#include <vector>

using namespace cv;
using namespace std;

#import "ImageCompared.h"

@implementation ImageCompared


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(UIImage *)similarlyMatchWithBox:(UIImage *)boxImage andSence:(UIImage *)senceImage{
    
    if (boxImage && senceImage) {
        
        cv::Mat sence,box;
        box = [self cvMatFromUIImage:boxImage];
        sence = [self cvMatFromUIImage:senceImage];
        
        cvtColor(box, box, CV_RGBA2RGB);
        cvtColor(sence, sence, CV_RGBA2RGB);
        
        vector<KeyPoint> keyPoints_obj, keyPoints_sence;
        Ptr<ORB> detector = ORB::create();
        
        detector->detect(box, keyPoints_obj);
        detector->detect(sence, keyPoints_sence);
        
        Mat description_box,description_sence;
        
        detector->compute(box, keyPoints_obj, description_box);
        detector->compute(sence, keyPoints_sence, description_sence);
        vector<DMatch> matches;
        
        Ptr<DescriptorMatcher> matcher = DescriptorMatcher ::create(cv::BFMatcher::BRUTEFORCE);
        
        // 处理拍的区域为黑色，比如手机平放在桌面上，会闪退
        if (description_sence.cols <= 0) {
            return nil;
        }
        
        if (description_sence.rows <= 0) {
            return nil;
        }
        
        matcher->match(description_box, description_sence, matches);
        
        // 发现匹配
        vector<DMatch> good_matches;
        
        for (unsigned int i = 0; i < matches.size(); i++) {
            //distance 值根据实际开发来调试
            if (matches[i].distance <= 320) {
                good_matches.push_back(matches[i]);
            }
        }
        
        Mat imgMatches;
        drawMatches(box,keyPoints_obj,sence,keyPoints_sence,good_matches,imgMatches,Scalar::all(-1),Scalar::all(-1),vector<char>(),DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS);
        
        UIImage *m = [self UIImageFromCVMat:imgMatches];
        return m;
        
    }
    
    return nil;
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image{
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC4);
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,cols,rows,8,cvMat.step[0],colorSpace,kCGImageAlphaNoneSkipLast |kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


@end
