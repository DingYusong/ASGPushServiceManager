//
//  ASGPushServiceManager.m
//  GoldWallet
//
//  Created by 丁玉松 on 2017/3/6.
//  Copyright © 2017年 Beijing Yingyan Internet Co., Ltd. All rights reserved.
//

#import "ASGPushServiceManager.h"
#import "ASGJPushManager.h"
#import "ASGUPushManager.h"

@interface ASGPushServiceManager ()<ASGJPushManagerDelegate,ASGUPushManagerDelegate>

@property (nonatomic ,strong) ASGUPushManager *UPushManager;
@property (nonatomic ,strong) ASGJPushManager *JPushManager;

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
        _UPushManager.delegate = self;
        [_UPushManager registerUPushInfoWithOptions:launchOptions UPushKey:_UPushKey];
    }
    
    if (self.JPushKey) {
        _JPushManager.delegate = self;
        [_JPushManager registerJPushInfoWithOptions:launchOptions JPushKey:_JPushKey forProduction:isProduction];
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


#pragma mark - setter

-(void)setUPushKey:(NSString *)UPushKey{
    _UPushKey = UPushKey;
    _UPushManager = [ASGUPushManager new];
}

-(void)setJPushKey:(NSString *)JPushKey{
    _JPushKey = JPushKey;
    _JPushManager = [ASGJPushManager new];
}


@end

