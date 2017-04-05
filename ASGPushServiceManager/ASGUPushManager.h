//
//  ASGUPushManager.h
//  Pods
//
//  Created by 丁玉松 on 2017/4/5.
//
//

#import <Foundation/Foundation.h>

#import "UMessage.h"

@protocol ASGUPushManagerDelegate <NSObject>

-(void)handlePushNotifation:(NSDictionary *)userInfo;

@end

/**
 *  友盟推送
 */
@interface ASGUPushManager : NSObject

@property (nonatomic ,assign) id<ASGUPushManagerDelegate> delegate;

/**
 *  配置友盟推送信息
 *
 *  @param launchOptions
 */
- (void)registerUPushInfoWithOptions:(NSDictionary *)launchOptions UPushKey:(NSString *)UPushKey;

@end

