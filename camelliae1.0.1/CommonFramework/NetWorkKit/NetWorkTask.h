//
//  NetWorkTask.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetWorkDelegate.h"
#import "AFNetworking.h"

@interface NetWorkTask : NSObject

/**获取当前网络类型(此方法不能判断是否真正的网络连通)*/
+ (NSString *) getCurrentNetType;

/**发送post请求*/
+ (BOOL) postResquestWithApiName:(NSString *)apiName
                         paraDic:(NSDictionary *)paraDic
                        delegate:(NetWorkDelegate *)netWorkDelegate;

/**图片处理*/
+ (void) setImageView:(UIImageView *) imageView
              WithURL:(NSString *)url
     placeholderImage:(UIImage *) image
         alterImageID:(NSString *) imageID;


+ (void)setImageView:(UIImageView *)imageView
             WithURL:(NSURL *)url
    placeholderImage:(UIImage *)placeholder;
@end
