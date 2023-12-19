import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:imoney_saver/net/notification_api.dart';
import 'package:imoney_saver/provider/notification_provider.dart';
import 'package:imoney_saver/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({Key? key}) : super(key: key);
  @override
  NotificationSettingState createState() => NotificationSettingState();
}

class NotificationSettingState extends State<NotificationSetting> {
  // bool _lights = false;

  TimeOfDay selectedTime = TimeOfDay.now();
  String schedule = '';
  // String setTodayTime = '';

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime24Hour = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 00),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (selectedTime24Hour != null && selectedTime24Hour != selectedTime) {
      setState(() {
        selectedTime = selectedTime24Hour;
        var hour = selectedTime.hour;
        var min = selectedTime.minute;
        var setTodayTime =
            TimeOfDay(hour: hour, minute: min).format(context).toString();
        var msgList = [
          'Please update your income and expenses. Thank you!',
          'Did you miss updating your income and expenses?',
          'It is time to update your income and expenses.'
        ];
        final _random = new Random();
        var msg = msgList[_random.nextInt(msgList.length)];
        NotificationApi.removeNotification(0);
        NotificationApi.showScheduledNotificationDaily(
            title: 'Reminder',
            body: msg,
            payload: '',
            scheduleDate: Time(
                selectedTime.hour, selectedTime.minute)); //Run every 12 seconds
        Provider.of<ScheduleProvider>(context, listen: false)
            .setPrefs(setTodayTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Reminder')),
        body: Column(
          children: [
            Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                margin: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 10, right: 10),
                child: InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer<ScheduleProvider>(builder:
                                  (context, ScheduleProvider value, child) {
                                return Text('Time:' + value.schedule);
                              }),
                              Icon(Icons.calendar_today, size: 25)
                            ])))
                // ),
                ),
          ],
        ));
  }
}
