//
//  PushNotifViewController.swift
//  MeetingCalendar
//
//  Created by Haesoo Kim on 18/12/2019.
//  Copyright © 2019 Haesoo Kim. All rights reserved.
//
import UserNotifications

class LocalNotificationManager
{
    //singleton
    static let notifManager = LocalNotificationManager()
    
    var notifications = [Notification]()
    
    func listScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            notifications in
        }
    }
    
    private func requestAuthorization()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { granted, error in
            
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)
            
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                
                guard error == nil else { return }

            }
        }
    }
    
}

struct Notification {
    var id:String
    var title:String
    var datetime:DateComponents
}
