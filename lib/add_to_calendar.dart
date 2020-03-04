import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum FrequencyType { DAILY, WEEKLY, MONTHLY }

class AddToCalendar {
  @visibleForTesting
  static const MethodChannel channel = const MethodChannel('add_to_calendar');

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
  }) {
    assert(title != null && title.isNotEmpty);
    assert(startTime != null);
    assert(isAllDay != null || endTime != null);
    assert(isAllDay != (endTime != null)); // XOR. You give either endTime or isAllDay
    assert(frequencyType != null && frequency != null || frequencyType == null && frequency == null);
    return channel.invokeMethod('addToCalendar', <String, dynamic>{
      'title': title,
      'startTime': startTime.toUtc().millisecondsSinceEpoch,
      'endTime': isAllDay ? startTime.toUtc().millisecondsSinceEpoch : endTime.toUtc().millisecondsSinceEpoch,
      'isAllDay': isAllDay,
      'location': location,
      'description': description,
      'frequency': frequency,
      'frequencyType': frequencyType.toString().split('.').last,
    });
  }
}
