//
//  NotificationExtension.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 04/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

// MARK: - It is made to make giving names to notifications easier
extension Notification.Name {
    

    static let notificationInternetIsOn = Notification.Name("notificationInternetIsOn")
    static let notificationInternetIsOff = Notification.Name("notificationInternetIsOff")
    /// When generic error like incorrect JSON, server down occurs
    static let notificationGenericError =
        Notification.Name("notificationGenericError")
}
