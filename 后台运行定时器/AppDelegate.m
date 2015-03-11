//
//  AppDelegate.m
//  后台运行定时器
//
//  Created by 陈家庆 on 15-3-11.
//  Copyright (c) 2015年 shikee. All rights reserved.
//

#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>//添加框架

@implementation AppDelegate{
    NSTimer *_timer;
    NSInteger _count;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    //应用可以后台运行的设置
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
    
    //添加定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startListen:) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //设置永久后台运行
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
    _count = 0;
}
-(void)startListen:(NSTimer *)timer{
    NSLog(@"正在后台运行");
    _count++;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    NSLog(@"后台运行计数值为：%ld",_count);
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
