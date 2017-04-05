//
//  ASGJPushManager.m
//  Pods
//
//  Created by 丁玉松 on 2017/4/5.
//
//

#import "ASGJPushManager.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>

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
