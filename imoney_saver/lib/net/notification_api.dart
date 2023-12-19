import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

//https://www.youtube.com/watch?v=bRy5dmts3X8

class NotificationApi {
  static final notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();
  static Future notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel id",
          "channel name",
          // "channel description",
          importance: Importance.max,
          playSound: true,
        ),
        iOS: IOSNotificationDetails());
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await notification.initialize(settings,
        onSelectNotification: (payload) async {
      onNotification.add(payload!);
    });

    //Getting GMT timezone Error in Emulator
    //Must Use actual Device
    if (initScheduled && !kDebugMode) {
      //This is important to make scheduled notification work
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      // print(locationName);
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      {
        notification.show(id, title, body, await notificationDetails(),
            payload: payload)
      };
//Normal Scheduling
  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async =>
      {
        notification.zonedSchedule(
            id,
            title,
            body,
            payload: payload,
            tz.TZDateTime.from(scheduleDate, tz.local),
            await notificationDetails(),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime)
      };
// NotificationApi.showScheduledNotification(
  //     title: '',
  //     body: '',
  //     payload: '',
  //     scheduleDate: DateTime.now()
  //         .add(Duration(seconds: 12)));//Run every 12 seconds
  static Future showScheduledNotificationDaily({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required Time scheduleDate,
  }) async =>
      {
        notification.zonedSchedule(
            id,
            title,
            body,
            _scheduleDaily(scheduleDate), //8am Time(8,3,12)
            await notificationDetails(),
            payload: payload,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time)
      };
  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduleDate.isBefore(now) //check if in the path already
        ? scheduleDate
            .add(Duration(days: 1)) //scheduled next day if already in the path
        : scheduleDate;
  }

  static Future showScheduledNotificationWeekly({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async =>
      {
        notification.zonedSchedule(
            id,
            title,
            body,
            _scheduleWeekly(Time(8), days: [
              DateTime.monday,
              DateTime.tuesday
            ]), //8am every monday and tuesday
            await notificationDetails(),
            payload: payload,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime)
      };
  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
    tz.TZDateTime scheduleDate = _scheduleDaily(time); //reuse _scheduleDaily
    while (!days.contains(scheduleDate.weekday)) {
      //check to add only weekdays in the schedule
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  static Future removeAllNotification() async {
    await notification.cancelAll();
  }

  static Future removeNotification(int id) async {
    await notification.cancel(id);
  }
}
