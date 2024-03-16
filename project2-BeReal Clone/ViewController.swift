import UIKit
import UserNotifications

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate of the notification center
        UNUserNotificationCenter.current().delegate = self
        
        // Request authorization to display notifications
        requestNotificationAuthorization()
        
        // Trigger a local notification after a delay (e.g., 5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.triggerLocalNotification()
        }
    }

    func requestNotificationAuthorization() {
        // Request authorization to display notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }

    func triggerLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "YourNotificationIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error triggering local notification: \(error.localizedDescription)")
            } else {
                print("Local notification triggered successfully")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // Handle notification presentation when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display the notification banner while the app is in the foreground
        completionHandler([.banner, .sound, .badge])
    }
}
