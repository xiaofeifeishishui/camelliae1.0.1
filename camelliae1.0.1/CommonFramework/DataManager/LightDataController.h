//
//  LightDataController.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetailInfoObj.h"

@interface LightDataController : NSObject

/**保存skey*/
- (void)saveSkey:(NSString *)skey;
- (NSString *)readSkey;
- (void)removeSkey;

/**userID*/
- (void) saveUserID:(NSNumber *)uid;
- (NSNumber *)readUserID;
- (void)removeUserID;

/**保存城市ID*/
- (void) saveCityID:(NSNumber *)cityID;
- (NSNumber *)readCityID;
- (void) removeCityID;

 /**存储手机号*/
- (void) savePhone:(NSString *) phone;
- (NSString *)readPhone;
- (void) removePhone;

/**real name*/
- (void) saveUserName:(NSString *)userName;
- (NSString *)readUserName;
- (void) removeUserName;

/**memberlvl*/
- (void) saveUserLevel:(NSNumber *)userLevel;
- (NSNumber *)readUserLevel;
- (void) removeUserLevel;

- (void) saveUserPoints:(NSNumber *)userPoints;
- (NSNumber *)readUserPoints;
- (void) removeUserPoints;
@end
