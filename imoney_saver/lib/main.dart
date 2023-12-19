import 'package:flutter/material.dart';
import 'package:imoney_saver/provider/detail_provider.dart';
import 'package:imoney_saver/provider/googlesignin_provider.dart';
import 'package:imoney_saver/provider/notification_provider.dart';
import 'package:imoney_saver/provider/theme_provider.dart';
import 'package:imoney_saver/routes/route_generator.dart';
// import 'package:imoney_saver/views/about.dart';
import 'package:imoney_saver/views/widgets/lists.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:provider/provider.dart';
// import 'models/db_model.dart';
// import 'models/money_saver_model.dart';
// import 'models/money_saver_model.dart';
import 'net/notification_api.dart';
import 'views/widgets/navigation.dart';
import 'package:imoney_saver/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //await getDatabasesPath(); requirement
  // var db = DatabaseConnect();
  // await db.deleteAlldata();
  // await db.insertData(MoneySaverModel(
  //     remarks: 'Test income remarks',
  //     money: 100.45,
  //     category: 'Income',
  //     creationDate: DateTime.now(),
  //     isChecked: false));
  // // print(await db.getData());
  // await db.insertData(MoneySaverModel(
  //     remarks: 'Test income remarks',
  //     money: 200.34,
  //     category: 'Income',
  //     creationDate: DateTime.now(),
  //     isChecked: false));
  // await db.insertData(MoneySaverModel(
  //     remarks: 'Test expense remarks',
  //     money: 150.28,
  //     category: 'Expense',
  //     creationDate: DateTime.now(),
  //     isChecked: false));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MoneySaverDetailProvider()),
      ChangeNotifierProvider(create: (context) => MoneySaverThemeProvider()),
      ChangeNotifierProvider(create: (context) => ScheduleProvider()),
      ChangeNotifierProvider(
          create: (context) =>
              GoogleSignInProvider()) //MaterialApp not detected),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final String appTitle = "Money Saver";
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<MoneySaverThemeProvider>(
        builder: (context, MoneySaverThemeProvider value, child) {
      return MaterialApp(
          title: appTitle,
          theme: value.darkTheme ? Themes.darkTheme : Themes.lightTheme,
          darkTheme: value.darkTheme ? Themes.darkTheme : Themes.lightTheme,
          themeMode: value.darkTheme ? darkThememode : lightThememode,
          initialRoute: '/',
          onGenerateRoute: RouterGenerator.generateRoute);
    });
    // );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<Home> {
  DateTime selectedDate = DateTime.now();
  final appName = const Text('Money Saver');
  String _month = DateFormat("MMMM").format(DateTime.now()).toString();
  String dateStr = '';

  @override
  void initState() {
    super.initState();
    _month = DateFormat("MMMM").format(DateTime.now()).toString();
    NotificationApi.init(initScheduled: true);

    listenNotification();
  }

  void listenNotification() =>
      NotificationApi.onNotification.stream.listen(onClickNotification);
  void onClickNotification(String? payload) {
    //Do something you want when clicked notification
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => MoneySaverAbout(payload: payload)));
    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Home()));
    // Navigator.of(context).pushNamed('/');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _month = DateFormat("MMMM").format(picked).toString();
        dateStr = DateFormat('MM-yyyy').format(selectedDate).toString();
        Provider.of<MoneySaverDetailProvider>(context, listen: false)
            .getSelectedDataProvider(dateStr);
        // print('dateStr:' + dateStr); //dateStr:06-2022
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appName, actions: <Widget>[
        Text(_month,
            style: const TextStyle(
                height: 3, fontSize: 15, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
              onPressed: () => _selectDate(context),
              //
              icon: const Icon(Icons.calendar_month, size: 25)),
        ),
      ]),
      drawer: NavigationDrawer(),
      body: Column(children: const [MoneySaverList()]),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Details',
        onPressed: () => Navigator.of(context).pushNamed('/detail_add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
