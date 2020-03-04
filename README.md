# add_to_calendar

[![pub package](https://img.shields.io/pub/v/add_to_calendar.svg)](https://pub.dartlang.org/packages/add_to_calendar)

Flutter plugin that allows opening a native UI to add an event with custom parameters to user's calendar

## Installation

Declare a pubspec dependency in your Flutter project.

### In iOS

Add `NSCalendarsUsageDescription` String entry in your info.plist explaining why you require calendar access permissions.

## What is it for?

It allows developers

## How to use it?

You can check the Example app to see a real use case on how to trigger the native view to add custom events to user's calendar. Snippet of the main function of the plugin:

```dart
  /// Function responsible of triggering the native view to create a custom event in user's calendar using given parameters
  /// 
  /// [title] is String value of the title to be filled
  /// [startTime] DateTime with the start time of the event
  /// [endTime] DateTime with the end time of the event. Optional if [isAllDay] is true, required otherwise.
  /// [isAllDay] bool value stating if the event will be a full day event
  /// [location] optional String with the location of the event
  /// [description] optional String with the description of the event
  /// [frequency] optional int with the information about recurrence of the event
  /// [frequencyType] optional enum that states the frequency. Daily, weekly, monthly
  /// 
  static Future addToCalendar({
    @required String title,
    @required DateTime startTime,
    DateTime endTime,
    bool isAllDay = false,
    String location,
    String description,
    int frequency,
    FrequencyType frequencyType,
  })
```
