//
//  ASGPushServiceManager.m
//  GoldWallet
//
//  Created by 丁玉松 on 2017/3/6.
//  Copyright © 2017年 Beijing Yingyan Internet Co., Ltd. All rights reserved.
//

#import "ASGPushServiceManager.h"
#import <AdSupport/AdSupport.h>

@interface ASGPushServiceManager ()<ASGJPushManagerDelegate,ASGUPushManagerDelegate>

@end

@implementation ASGPushServiceManager

/*单例*/
+(ASGPushServiceManager *)shareInstance
{
    static ASGPushServiceManager *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ASGPushServiceManager alloc]init];
    });
    return helper;
}

-(void)registerJPushInfoWithOptions:(NSDictionary *)launchOptions delegate:(id)delegate forProduction:(BOOL)isProduction{
    
    self.delegate = delegate;
    
    if (self.UPushKey) {
        [ASGUPushManager shareInstance].delegate = self;
        [[ASGUPushManager shareInstance] registerUPushInfoWithOptions:launchOptions UPushKey:_UPushKey];
    }
    
    if (self.JPushKey) {
        [ASGJPushManager shareInstance].delegate = self;
        [[ASGJPushManager shareInstance] registerJPushInfoWithOptions:launchOptions JPushKey:_JPushKey forProduction:isProduction];
    }
}

- (void)registerDeviceToken:(NSData *)deviceToken{
    
    
    if (self.UPushKey) {
        [UMessage registerDeviceToken:deviceToken];
        NSString *pushToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                stringByReplacingOccurrencesOfString: @">" withString: @""]
                               stringByReplacingOccurrencesOfString: @" " withString: @""];
        NSLog(@"deviceToken:%@",pushToken);
        
        if ([self.delegate respondsToSelector:@selector(clentReceivedUPushDeviceToken:)]) {
            [self.delegate clentReceivedUPushDeviceToken:pushToken];
        }
    }
    
    if (self.JPushKey) {
        [JPUSHService registerDeviceToken:deviceToken];
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            if(resCode == 0){
                NSLog(@"registrationID获取成功：%@",registrationID);
                if ([self.delegate respondsToSelector:@selector(clentReceivedJPushID:)]) {
                    [self.delegate clentReceivedJPushID:registrationID];
                }
            } else {
                NSLog(@"registrationID获取失败，code：%d",resCode);
            }
        }];
    }
}


    
    
-(void)handlePushNotifation:(NSDictionary *)userInfo{
    NSLog(@"userInfo:%@",userInfo);
    
    if (self.UPushKey) {
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    if (self.JPushKey) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    if ([self.delegate respondsToSelector:@selector(handleNotifation:)]) {
        [self.delegate handleNotifation:userInfo];
    }
}

@end

#pragma mark - 极光推送

@interface ASGJPushManager ()<JPUSHRegisterDelegate>

@end

@implementation ASGJPushManager

/*单例*/
+(ASGJPushManager *)shareInstance
{
    static ASGJPushManager *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ASGJPushManager alloc]init];
    });
    return helper;
}


-(void)registerJPushInfoWithOptions:(NSDictionary *)launchOptions JPushKey:(NSString *)JPushKey forProduction:(BOOL)isProduction
{    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushKey
                          channel:@"AppStore"
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}


#pragma mark- JPUSHRegisterDelegate（iOS10）

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        if ([self.delegate respondsToSelector:@selector(handlePushNotifation:)]) {
            [self.delegate handlePushNotifation:userInfo];
        }
    }
    completionHandler(UNNotificationPresentationOptionSound);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        if ([self.delegate respondsToSelector:@selector(handlePushNotifation:)]) {
            [self.delegate handlePushNotifation:userInfo];
        }
    }
    completionHandler();  // 系统要求执行这个方法
}



@end

#pragma mark - 友盟推送

@interface ASGUPushManager ()<UNUserNotificationCenterDelegate>

@end

@implementation ASGUPushManager

/*单例*/
+(ASGUPushManager *)shareInstance
{
    static ASGUPushManager *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ASGUPushManager alloc]init];
    });
    return helper;
}


- (void)registerUPushInfoWithOptions:(NSDictionary *)launchOptions UPushKey:(NSString *)UPushKey {
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:UPushKey launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //log
    [UMessage setLogEnabled:YES];
    
    [UMessage setAutoAlert:NO];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
        } else {
            //点击不允许
        }
    }];
}


#pragma mark - UNUserNotificationCenterDelegate

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        if ([self.delegate respondsToSelector:@selector(handlePushNotifation:)]) {
            [self.delegate handlePushNotifation:userInfo];
        }
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound);  // 系统要求执行这个方法
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        if ([self.delegate respondsToSelector:@selector(handlePushNotifation:)]) {
            [self.delegate handlePushNotifation:userInfo];
        }
    }else{
        //应用处于后台时的本地推送接受
    }
    completionHandler();// 系统要求执行这个方法
}


@end



