//
//  NetWorkTask.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NetWorkTask.h"
#import "NetConfig.h"
#import "UIImageView+WebCache.h"

@implementation NetWorkTask

/**获得当前网络状态*/
+ (NSString *) getCurrentNetType{

    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    for (id view in subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[view valueForKeyPath:@"dataNetworkType"] intValue];
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
                default:
                    break;
            }
        }
    }
    return state;
    
    return nil;
}


+ (BOOL) postResquestWithApiName:(NSString *)apiName
                         paraDic:(NSDictionary *)paraDic
                        delegate:(NetWorkDelegate *)netWorkDelegate{

    NSString *requestString = [NSString stringWithFormat:@"%@%@",NetWorkApiDomain,apiName];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",
                                                        @"text/json",
                                                        @"text/javascript",
                                                        @"text/html",
                                                        @"text/plain",
                                                        nil];
   
    /**发送post请求*/
     NSString *netType = [self getCurrentNetType];
    /**当有网时才能请求*/
    if (![netType isEqualToString:@"无网络"]) {
        [manager POST:requestString parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

            if ([netWorkDelegate.delegate respondsToSelector:@selector(requestSucceedBack:withApiName:)]) {
                [netWorkDelegate.delegate requestSucceedBack:responseObject withApiName:apiName];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([netWorkDelegate.delegate respondsToSelector:@selector(requestFailBack:withApiName:)]) {
                [netWorkDelegate.delegate requestFailBack:error withApiName:apiName];
            }
        }];
    }else{
    
    }
    return nil;
}

+ (void) setImageView:(UIImageView *) imageView WithURL:(NSURL *)url placeholderImage:(UIImage *) image{

    [imageView setImageWithURL:url placeholderImage:image];

}
@end
