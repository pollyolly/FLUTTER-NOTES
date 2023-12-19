import 'package:flutter/material.dart';

class MoneySaverRate extends StatelessWidget {
  const MoneySaverRate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Rate')),
        body: Column(
          children: const [
            Expanded(
              child: Text('Rate'),
            )
          ],
        ));
  }
}
