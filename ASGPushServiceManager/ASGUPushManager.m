//
//  ASGUPushManager.m
//  Pods
//
//  Created by 丁玉松 on 2017/4/5.
//
//

#import "ASGUPushManager.h"

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



