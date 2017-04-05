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

@end



