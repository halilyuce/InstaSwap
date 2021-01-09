//
//  NotificationService.swift
//  Notifications
//
//  Created by Halil Yuce on 9.01.2021.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            if let notificationData = request.content.userInfo["notification"] as? String {
                
                let model = notificationData.parse(to: PushNotificationModel.self)
                let user = model?.notificationModel.user?.name ?? ""
                
                if model?.notificationModel.notificationType == 0 {
                    bestAttemptContent.title = "\(user)" + " shared his/her insta with you".localized
                    bestAttemptContent.body = "Stalk his/her insta and follow.".localized
                }else if model?.notificationModel.notificationType == 1 {
                    bestAttemptContent.title = "\(user)" + " want your insta".localized
                    bestAttemptContent.body = "Stalk his/her insta and accept or decline request.".localized
                }else if model?.notificationModel.notificationType == 2 {
                    bestAttemptContent.title = "\(user)" + " accepted your request".localized
                    bestAttemptContent.body = "\(user)" + " want to share his/her insta with you.".localized
                }else if model?.notificationModel.notificationType == 3 {
                    bestAttemptContent.title = "\(user)" + " declined your request".localized
                    bestAttemptContent.body = "\(user)" + " dont want to share his/her insta with you.".localized
                }
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

extension String {

    func parse<D>(to type: D.Type) -> D? where D: Decodable {

        let data: Data = self.data(using: .utf8)!

        let decoder = JSONDecoder()

        do {
            let _object = try decoder.decode(type, from: data)
            return _object

        } catch {
            return nil
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
