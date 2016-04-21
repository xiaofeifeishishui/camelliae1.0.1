//
//  NetWorkDelegate.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetWorkProtocol <NSObject>

@optional

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName;

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName;

@end

@interface NetWorkDelegate : NSObject

@property (nonatomic,strong) id<NetWorkProtocol>delegate;

@end
