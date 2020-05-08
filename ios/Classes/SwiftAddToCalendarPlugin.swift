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
            let startDate = dateFromNumber(arguments["startTime"] as! NSNumber)
            let frequency = arguments["frequency"] as? Int
            let frequencyType = frequencyTypeFromString(typeString: arguments["frequencyType"] as? String)
            if let endDateNumber = arguments["endTime"] as? NSNumber {
                self.addToCalendar(title: title, startDate: startDate, endDate: dateFromNumber(endDateNumber), location: location, description: description, isAllDay: allDay, frequency: frequency, frequencyType: frequencyType)
            } else {
                self.addToCalendar(title: title, startDate: startDate, endDate: nil, location: location, description: description, isAllDay: allDay, frequency: frequency, frequencyType: frequencyType)
            }
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    func frequencyTypeFromString(typeString: String?) -> EKRecurrenceFrequency? {
        switch typeString {
            case "DAILY":
                return EKRecurrenceFrequency.daily
            case "WEEKLY":
                return EKRecurrenceFrequency.weekly
            case "MONTHLY":
                return EKRecurrenceFrequency.monthly
            default:
                return nil
        }
    }

    func dateFromNumber(_ millis: NSNumber) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(truncating: millis) / 1000)
    }
    
    func addToCalendar(title: String, startDate: Date, endDate: Date?, location: String?, description: String?, isAllDay: NSNumber?, frequency: Int?, frequencyType: EKRecurrenceFrequency?) {
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
                    
                    if (frequency != nil && frequencyType != nil){
                        let recurrenceRule = EKRecurrenceRule.init(
                            recurrenceWith: frequencyType!,
                            interval: frequency!,
                            daysOfTheWeek: nil,
                            daysOfTheMonth: nil,
                            monthsOfTheYear: nil,
                            weeksOfTheYear: nil,
                            daysOfTheYear: nil,
                            setPositions: nil,
                            end: nil
                        )
                        
                        event.recurrenceRules = [recurrenceRule]
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
