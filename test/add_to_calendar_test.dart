import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:add_to_calendar/add_to_calendar.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  MockMethodChannel mockChannel;

  setUp(() {
    mockChannel = MockMethodChannel();
    AddToCalendar.channel.setMockMethodCallHandler((MethodCall call) async {
      mockChannel.invokeMethod(call.method, call.arguments);
    });
  });

  test('add to calendar null title fails', () {
    expect(
      () => AddToCalendar.addToCalendar(
            title: null,
            startTime: DateTime.now(),
          ),
      throwsA(const TypeMatcher<AssertionError>()),
    );
    verifyZeroInteractions(mockChannel);
  });

  test('add to calendar empty title fails', () {
    expect(
      () => AddToCalendar.addToCalendar(
            title: '',
            startTime: DateTime.now(),
          ),
      throwsA(const TypeMatcher<AssertionError>()),
    );
    verifyZeroInteractions(mockChannel);
  });

  test('add to calendar null startTime fails', () {
    expect(
      () => AddToCalendar.addToCalendar(
            title: 'title',
            startTime: null,
          ),
      throwsA(const TypeMatcher<AssertionError>()),
    );
    verifyZeroInteractions(mockChannel);
  });

  test('add to calendar not giving endTime when not all day fails', () {
    expect(
      () => AddToCalendar.addToCalendar(
            title: 'title',
            startTime: DateTime.now(),
          ),
      throwsA(const TypeMatcher<AssertionError>()),
    );
    verifyZeroInteractions(mockChannel);
  });

  test('add to calendar giving endTime and all day fails', () {
    expect(
      () => AddToCalendar.addToCalendar(
            title: 'title',
            startTime: DateTime.now(),
            endTime: DateTime.now(),
            isAllDay: true,
          ),
      throwsA(const TypeMatcher<AssertionError>()),
    );
    verifyZeroInteractions(mockChannel);
  });

  test('adds to calendar when defined all day and not giving endTime', () async {
    final dateTime = DateTime.now();
    await AddToCalendar.addToCalendar(title: 'title', startTime: dateTime, isAllDay: true);
    verify(mockChannel.invokeMethod('addToCalendar', <String, dynamic>{
      'title': 'title',
      'startTime': dateTime.toUtc().toIso8601String(),
      'endTime': null,
      'isAllDay': true,
      'location': null,
      'description': null,
    }));
  });

  test('adds to calendar when defined endTime and not all day', () async {
    final dateTime = DateTime.now();
    await AddToCalendar.addToCalendar(title: 'title', startTime: dateTime, endTime: dateTime);
    verify(mockChannel.invokeMethod('addToCalendar', <String, dynamic>{
      'title': 'title',
      'startTime': dateTime.toUtc().toIso8601String(),
      'endTime': dateTime.toUtc().toIso8601String(),
      'isAllDay': false,
      'location': null,
      'description': null,
    }));
  });

  test('adds to calendar with provided location information', () async {
    final dateTime = DateTime.now();
    await AddToCalendar.addToCalendar(title: 'title', startTime: dateTime, endTime: dateTime, location: 'location');
    verify(mockChannel.invokeMethod('addToCalendar', <String, dynamic>{
      'title': 'title',
      'startTime': dateTime.toUtc().toIso8601String(),
      'endTime': dateTime.toUtc().toIso8601String(),
      'isAllDay': false,
      'location': 'location',
      'description': null,
    }));
  });

  test('adds to calendar with provided description', () async {
    final dateTime = DateTime.now();
    await AddToCalendar.addToCalendar(title: 'title', startTime: dateTime, endTime: dateTime, description: 'description');
    verify(mockChannel.invokeMethod('addToCalendar', <String, dynamic>{
      'title': 'title',
      'startTime': dateTime.toUtc().toIso8601String(),
      'endTime': dateTime.toUtc().toIso8601String(),
      'isAllDay': false,
      'location': null,
      'description': 'description',
    }));
  });
}
