//
//  JAKAppDelegate.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 12.05.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "JAKAppDelegate.h"
#import "SimpleDataProvider.h"
//#import "TokenSenderEngine.h"


@implementation JAKAppDelegate

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef A
    DLog(@"This is A!");
    //-- Set Notification
/*
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];

        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }

*/

#else
    DLog(@"This is B!");
#endif
/*
    DLog(@"***");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    if (launchOptions != nil) {
        // Launched from push notification
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        DLog(@"Beep! %@", notification);

    }
*/
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
        self.window.tintColor = THEWHITE;
        [[UINavigationBar appearance] setBarTintColor:THECOLOR];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UIToolbar appearance] setBarTintColor:THECOLOR];
        [[UITextField appearance] setTintColor:THECOLOR];
        [[UISearchBar appearance] setBarTintColor:THECOLOR];
    }
    else {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:THECOLOR];
        [[UIBarButtonItem appearance] setTintColor:THECOLOR];
        [[UIToolbar appearance] setBackgroundImage:[[UIImage alloc] init]
                                forToolbarPosition:UIBarPositionBottom
                                        barMetrics:UIBarMetricsDefault];
        [[UIToolbar appearance] setBackgroundColor:THECOLOR];
        [[UISearchBar appearance] setTintColor:THECOLOR];
    }

    NSDictionary *attrDict = @{
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f]
                               };

    [[UINavigationBar appearance]setTitleTextAttributes:attrDict];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types
    // of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
    // Games should use this method to pause the game.
    [[SimpleDataProvider sharedInstance] persist];
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough
    // application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate:
    // when the user quits.
    [[SimpleDataProvider sharedInstance]persist];
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of
    // the changes made on entering the background.

}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
    /*DLog(@"***");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
     */

}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate.
    // See also applicationDidEnterBackground:.
    [[SimpleDataProvider sharedInstance]persist];
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"devToken=%@",deviceToken);

    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    [self sendToken:hexToken];
}

// -------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)sendToken:(NSString *)token
{
    TokenSenderEngine *senderEngine = [[TokenSenderEngine alloc] initWithHostName:@"www.honeywell-da.com"];
    [senderEngine sendToken:token toPath:@"/apn/register.php" onCompletion:^(MKNetworkOperation *completedOperation) {
        //DLog(@"answer: %@", completedOperation.responseString);
    }
    onError:^(NSError *error) {
        DLog(@"error : %@", error.localizedDescription);
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DLog(@"userInfo: %@", userInfo);
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        DLog(@"opened from a push notification when the app was on background!");
    } else {
        DLog(@"OTHER!");
    }
}
 */

@end
