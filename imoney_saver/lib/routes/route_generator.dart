import 'package:flutter/material.dart';
import 'package:imoney_saver/main.dart';
import 'package:imoney_saver/models/money_saver_arguments.dart';
import 'package:imoney_saver/views/chart.dart';
import 'package:imoney_saver/views/detail.dart';
import 'package:imoney_saver/views/setting.dart';
import 'package:imoney_saver/views/about.dart';
import 'package:imoney_saver/views/rate.dart';
import 'package:imoney_saver/views/detail_update.dart';
import 'package:imoney_saver/views/detail_add.dart';
import 'package:imoney_saver/views/settings/backup_setting.dart';
import 'package:imoney_saver/views/settings/notification_setting.dart';
import 'package:imoney_saver/views/settings/theme_setting.dart';

class RouterGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/chart':
        return MaterialPageRoute(builder: (_) => const MoneySaverChart());
      case '/setting':
        return MaterialPageRoute(builder: (_) => const MoneySaverSetting());
      case '/theme-setting':
        return MaterialPageRoute(builder: (_) => const ThemeSetting());
      case '/notification-setting':
        return MaterialPageRoute(builder: (_) => const NotificationSetting());
      case '/backup-setting':
        return MaterialPageRoute(builder: (_) => const BackupSetting());
      case '/about':
        return MaterialPageRoute(builder: (_) => const MoneySaverAbout());
      case '/rate':
        return MaterialPageRoute(builder: (_) => const MoneySaverRate());
      case '/detail':
        return MaterialPageRoute(
            builder: (_) =>
                MoneySaverDetails(data: args as MoneySaverArguments));
      case '/update-detail':
        return MaterialPageRoute(
            builder: (_) =>
                MoneySaverUpdateDetail(data: args as MoneySaverArguments));
      case '/detail_add':
        return MaterialPageRoute(builder: (_) => const MoneySaverAddDetail());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic>? _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
