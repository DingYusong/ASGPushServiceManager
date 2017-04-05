//
//  ASGPushServiceManager.h
//  GoldWallet
//
//  Created by 丁玉松 on 2017/3/6.
//  Copyright © 2017年 Beijing Yingyan Internet Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASGPushServiceManagerDelegate <NSObject>

-(void)clentReceivedUPushDeviceToken:(NSString *)deviceToken;
-(void)clentReceivedJPushID:(NSString *)JPushID;
-(void)handleNotifation:(NSDictionary *)userInfo;
    
@end


@interface ASGPushServiceManager : NSObject

@property (nonatomic ,assign) id<ASGPushServiceManagerDelegate> delegate;

@property (nonatomic ,copy) NSString *JPushKey;
@property (nonatomic ,copy) NSString *UPushKey;
/*单例*/
+ (ASGPushServiceManager *)shareInstance;

- (void)registerJPushInfoWithOptions:(NSDictionary *)launchOptions delegate:(id)delegate forProduction:(BOOL)isProduction;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)handlePushNotifation:(NSDictionary *)userInfo;

@end



#pragma mark - 极光推送
#import "JPUSHService.h"

@protocol ASGJPushManagerDelegate <NSObject>

-(void)handlePushNotifation:(NSDictionary *)userInfo;

@end

/**
 *  极光推送
 */
@interface ASGJPushManager : NSObject

@property (nonatomic ,assign) id<ASGJPushManagerDelegate> delegate;

+(ASGJPushManager *)shareInstance;

-(void)registerJPushInfoWithOptions:(NSDictionary *)launchOptions JPushKey:(NSString *)JPushKey forProduction:(BOOL)isProduction;
@end


#pragma mark - 友盟推送
#import "UMessage.h"

@protocol ASGUPushManagerDelegate <NSObject>

-(void)handlePushNotifation:(NSDictionary *)userInfo;

@end

/**
 *  友盟推送
 */
@interface ASGUPushManager : NSObject

@property (nonatomic ,assign) id<ASGUPushManagerDelegate> delegate;

+(ASGUPushManager *)shareInstance;

/**
 *  配置友盟推送信息
 *
 *  @param launchOptions
 */
- (void)registerUPushInfoWithOptions:(NSDictionary *)launchOptions UPushKey:(NSString *)UPushKey;

@end


