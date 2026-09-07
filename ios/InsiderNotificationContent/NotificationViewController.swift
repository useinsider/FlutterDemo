import InsiderMobileAdvancedNotification
import UIKit
import UserNotifications
import UserNotificationsUI

/// Notification content extension that renders Insider interactive push notifications
/// as an `iCarousel` of slides. The `carousel` outlet is wired by the SDK-provided
/// `InsiderInterface.storyboard`.
// The storyboard shipped in the pod references this class by its unmangled ObjC name.
@objc(NotificationViewController)
@MainActor public final class NotificationViewController: UIViewController, UNNotificationContentExtension, iCarouselDelegate, iCarouselDataSource {

    @IBOutlet public var carousel: iCarousel!

    // FIXME-INSIDER: Please change with your app group.
    private let appGroup = "group.com.useinsider.FlutterDemo"

    public override func viewDidLoad() {
        super.viewDidLoad()
        carousel.delegate = self
        carousel.dataSource = self
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        InsiderPushNotification.setTimeAttribution()
    }

    public func didReceive(_ notification: UNNotification) {
        InsiderPushNotification.interactivePushLoad(appGroup, superView: view, notification: notification)

        carousel.type = .rotary
        carousel.reloadData()

        InsiderPushNotification.interactivePushDidReceive()
    }

    public func didReceive(
        _ response: UNNotificationResponse,
        completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void
    ) {
        if response.actionIdentifier == "insider_int_push_next" {
            carousel.scrollToItem(
                at: InsiderPushNotification.didReceiveResponse(carousel.currentItemIndex),
                animated: true
            )
            completion(.doNotDismiss)
        } else {
            InsiderPushNotification.logPlaceholderClick(response)
            completion(.dismissAndForwardAction)
        }
    }

    public func numberOfItems(in carousel: iCarousel) -> Int {
        return InsiderPushNotification.getNumberOfSlide()
    }

    public func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        return InsiderPushNotification.getSlide(index, reusing: view, superView: self.view)
    }

    public func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return InsiderPushNotification.getItemWidth()
    }
}
