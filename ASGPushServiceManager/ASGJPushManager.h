//
//  ASGJPushManager.h
//  Pods
//
//  Created by 丁玉松 on 2017/4/5.
//
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"

@protocol ASGJPushManagerDelegate <NSObject>

-(void)handlePushNotifation:(NSDictionary *)userInfo;

@end

/**
 *  极光推送
 */
@interface ASGJPushManager : NSObject

@property (nonatomic ,assign) id<ASGJPushManagerDelegate> delegate;

-(void)registerJPushInfoWithOptions:(NSDictionary *)launchOptions JPushKey:(NSString *)JPushKey forProduction:(BOOL)isProduction;

@end
