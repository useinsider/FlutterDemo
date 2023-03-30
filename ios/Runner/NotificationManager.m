#import "NotificationManager.h"

@implementation NotificationManager

+ (instancetype)sharedManager {
    static NotificationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)configureNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    id source = [userInfo valueForKey:@"source"];

    if (source != [NSNull null] && [source isEqualToString:@"Insider"]) {
        [Insider triggerPushProcessWithUserInfo:userInfo];
    } else {
        if (@available(iOS 14, *)) {
            completionHandler(UNNotificationPresentationOptionSound +
                              UNNotificationPresentationOptionBadge +
                              UNNotificationPresentationOptionBanner +
                              UNNotificationPresentationOptionList);
        } else {
            completionHandler(UNNotificationPresentationOptionSound +
                              UNNotificationPresentationOptionBadge +
                              UNNotificationPresentationOptionAlert);
        }
    }
    
    
    /*
     OR, If you want all pushes (including Insider) to be shown, you should use the direct notification display code without discrimination.
     
     if (@available(iOS 14, *)) {
         completionHandler(UNNotificationPresentationOptionSound +
                           UNNotificationPresentationOptionBadge +
                           UNNotificationPresentationOptionBanner +
                           UNNotificationPresentationOptionList);
     } else {
         completionHandler(UNNotificationPresentationOptionSound +
                           UNNotificationPresentationOptionBadge +
                           UNNotificationPresentationOptionAlert);
     }
     */
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    id source = [userInfo valueForKey:@"source"];

    if (source != [NSNull null] && [source isEqualToString:@"Insider"]) {
        [Insider triggerPushProcessWithUserInfo:userInfo];
    }
    
    completionHandler();
}

@end
