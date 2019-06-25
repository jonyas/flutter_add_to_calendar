import Flutter
import UIKit
import EventKit
import EventKitUI

public class SwiftAddToCalendarPlugin: NSObject, FlutterPlugin, EKEventEditViewDelegate {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "add_to_calendar", binaryMessenger: registrar.messenger())
        let instance = SwiftAddToCalendarPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "addToCalendar":
            let arguments = call.arguments as! Dictionary<String, Any>
            let title = arguments["title"] as! String
            
            let location = arguments["location"] as? String
            let description = arguments["description"] as? String
            let allDay = arguments["isAllDay"] as? NSNumber
            let startDate = dateFromISOString(arguments["startTime"] as! String)
            
            if let endDateString = arguments["endTime"] as? String {
                self.addToCalendar(title: title, startDate: startDate, endDate: dateFromISOString(endDateString), location: location, description: description, isAllDay: allDay)
            } else {
                self.addToCalendar(title: title, startDate: startDate, endDate: nil, location: location, description: description, isAllDay: allDay)
            }
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    func dateFromISOString(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: string)!
    }
    
    func addToCalendar(title: String, startDate: Date, endDate: Date?, location: String?, description: String?, isAllDay: NSNumber?) {
        let eventStore = EKEventStore()
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = startDate
                    if (endDate != nil) {
                        event.endDate = endDate
                    }
                    event.location = location
                    event.notes = description
                    if (isAllDay != nil) {
                        event.isAllDay = isAllDay == 1
                    }
                    
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = eventStore
                    eventController.editViewDelegate = self
                    UIApplication.shared.keyWindow?.rootViewController?.present(eventController, animated: true, completion: nil)
                }
            }
        })
    }
    
    public func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
