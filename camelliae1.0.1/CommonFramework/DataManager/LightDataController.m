//
//  LightDataController.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "LightDataController.h"

@interface LightDataController ()

@property (nonatomic,strong) NSUserDefaults *defaults;
@end

@implementation LightDataController

- (instancetype)init{

    self = [super init];
    
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

/**保存skey*/
- (void)saveSkey:(NSString *)skey{
    [self.defaults setObject:skey forKey:@"skey"];
}
- (NSString *)readSkey{
    return [self.defaults objectForKey:@"skey"];
}
- (void)removeSkey{
    [self.defaults removeObjectForKey:@"skey"];
}



- (void) saveUserID:(NSNumber *)uid{
    [self.defaults setObject:uid forKey:@"userID"];
}
- (NSNumber *)readUserID{
    return [self.defaults objectForKey:@"userID"];
}
- (void)removeUserID{
    [self.defaults removeObjectForKey:@"userID"];
}

/**保存城市ID*/

- (void) saveCityID:(NSNumber *)cityID{
  [self.defaults setObject:cityID forKey:@"currentCityID"];
}
- (NSNumber *)readCityID{
   return [self.defaults objectForKey:@"currentCityID"];
}
- (void) removeCityID{

    [self.defaults removeObjectForKey:@"currentCityID"];
}

/**存储手机号*/
- (void) savePhone:(NSString *) phone{
  [self.defaults setObject:phone forKey:@"phone"];
}
- (NSString *)readPhone{
   return [self.defaults objectForKey:@"phone"];
}
- (void) removePhone{
   [self.defaults removeObjectForKey:@"phone"];
}

/**real name*/
- (void) saveUserName:(NSString *)userName{
  [self.defaults setObject:userName forKey:@"userName"];
}
- (NSString *)readUserName{
   return [self.defaults objectForKey:@"userName"];
}
- (void) removeUserName{
   [self.defaults removeObjectForKey:@"userName"];
}

/**memberlvl*/
- (void) saveUserLevel:(NSNumber *)userLevel{

    [self.defaults setObject:userLevel forKey:@"userLevel"];
}
- (NSNumber *)readUserLevel{
    return [self.defaults objectForKey:@"userLevel"];
}
- (void) removeUserLevel{

 [self.defaults removeObjectForKey:@"userLevel"];
}
@end
