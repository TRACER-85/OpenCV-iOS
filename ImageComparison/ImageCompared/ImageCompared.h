//
//  ImageCompared.h
//  ImageComparison
//
//  Created by TRACER on 2019/11/21.
//  Copyright © 2019 TRACER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCompared : NSObject


/**
 <#Description#>

 @param boxImage 模板图片
 @param senceImage 实时图片
 @return 对比图片
 */
-(UIImage *)similarlyMatchWithBox:(UIImage *)boxImage andSence:(UIImage *)senceImage;

@end

NS_ASSUME_NONNULL_END
