import InsiderMobileAdvancedNotification
@preconcurrency import UserNotifications

/// Notification service extension that lets the Insider SDK attach rich push media
/// (images, carousels) to incoming Insider notifications before they are displayed.
public final class NotificationService: UNNotificationServiceExtension {

    nonisolated(unsafe) private var contentHandler: ((UNNotificationContent) -> Void)?
    nonisolated(unsafe) private var bestAttemptContent: UNMutableNotificationContent?

    // FIXME-INSIDER: Please change with your app group.
    private let appGroup = "group.com.useinsider.mobile-ios"

    public override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping @Sendable (UNNotificationContent) -> Void
    ) {
        guard
            let bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
        else { return }
        defer {
            self.contentHandler = contentHandler
            self.bestAttemptContent = bestAttemptContent
        }
        if let source = bestAttemptContent.userInfo["source"] as? String,
           source == "Insider" {
            // MARK: You can customize these.
            InsiderPushNotification.showInsiderRichPush(
                bestAttemptContent,
                appGroup: appGroup,
                nextButtonText: ">>",
                goToAppText: "Launch App",
                success: { attachment in
                    if let attachment {
                        bestAttemptContent.attachments = [attachment]
                    }
                    contentHandler(bestAttemptContent)
                }
            )
        } else {
            // Handle other rich push providers in here.
        }
    }

    public override func serviceExtensionTimeWillExpire() {
        if let contentHandler, let bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
