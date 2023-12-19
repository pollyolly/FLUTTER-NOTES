import 'package:flutter/material.dart';

class MoneySaverAbout extends StatelessWidget {
  const MoneySaverAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('About')),
        body: Column(
          children: const [
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text('Money Saver',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      )),
                )),
            Center(
              child: Text('Version 1.0'),
            )
          ],
        ));
  }
}
