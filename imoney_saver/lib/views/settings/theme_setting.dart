import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imoney_saver/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSetting extends StatefulWidget {
  const ThemeSetting({Key? key}) : super(key: key);
  @override
  ThemeSettingState createState() => ThemeSettingState();
}

class ThemeSettingState extends State<ThemeSetting> {
  // bool _lights = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Theme Setting')),
        body: Column(
          children: [
            Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                margin: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 10, right: 10),
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Light/Dark Mode:'),
                          SizedBox(child: Consumer<MoneySaverThemeProvider>(
                              builder: (context, value, child) {
                            return CupertinoSwitch(
                                activeColor: value.darkTheme
                                    ? Colors.black12
                                    : Colors.orange,
                                value: value.darkTheme,
                                onChanged: (_) => value.toggleTheme());
                          })),
                        ]))
                // ),
                ),
          ],
        ));
  }
}
