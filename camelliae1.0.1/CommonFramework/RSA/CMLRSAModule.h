//
//  CMLRSAModule.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/22.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMLRSAModule : NSObject

/***/
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;

+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;

+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;

+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;

+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;
@end
