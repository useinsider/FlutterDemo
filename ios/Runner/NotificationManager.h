#import <Foundation/Foundation.h>
#import <InsiderMobile/Insider.h>
#import <UserNotifications/UserNotifications.h>

@interface NotificationManager : NSObject <UNUserNotificationCenterDelegate>

+ (instancetype)sharedManager;
- (void)configureNotification;

@end
