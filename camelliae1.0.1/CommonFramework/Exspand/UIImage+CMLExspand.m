//
//  UIImage+CMLExspand.m
//  camelliae1.0
//
//  Created by 张越 on 16/4/14.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "UIImage+CMLExspand.h"

@implementation UIImage (CMLExspand)

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)scaleToRect:(UIImage *)img {

    size_t CGImageGetWidth(CGImageRef img);
    size_t CGImageGetHeight(CGImageRef img);

    CGImageRef cgRef = img.CGImage;
    float height = CGImageGetHeight(cgRef);
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(0,0,height,height));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbScale;
    
}

+ (UIImage*) scaleToSizeOfHeight280:(UIImage *) img{

    CGSize size = CGSizeMake(img.size.width, img.size.height/304*280);
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,img.size.height/304*((304 - 280)/2.0), size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;

}
@end
