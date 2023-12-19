import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:imoney_saver/provider/googlesignin_provider.dart';
import 'package:imoney_saver/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/transformers.dart';
// import 'dart:async';
// import 'dart:convert' show json;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  NavigationDrawerState createState() => NavigationDrawerState();
}

class NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(child:
        Consumer2<MoneySaverThemeProvider, GoogleSignInProvider>(
            builder: (context, theme, gsignin, child) {
      // ImageProvider
      var photo = gsignin.currentUser?.photoUrl;
      return ListView(padding: EdgeInsets.zero, children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              color: theme.darkTheme ? Colors.black12 : Colors.orange),
          accountName: Text(
            gsignin.currentUser?.displayName ?? 'Username',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            gsignin.currentUser?.email ?? 'Email',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          currentAccountPicture: photo != null
              ? CircleAvatar(radius: 30.0, backgroundImage: NetworkImage(photo))
              : const CircleAvatar(backgroundColor: Colors.white),
        ),
        ListTile(
            title: const Text('Charts'),
            onTap: () {
              Navigator.of(context).pushNamed('/chart');
            }),
        ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/setting');
            }),
        ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.of(context).pushNamed('/about');
            }),
        ListTile(
            title: const Text('Rate'),
            onTap: () {
              Navigator.of(context).pushNamed('/rate');
            }),
        // ListTile(
        //     title: const Text('Refresh'),
        //     onTap: () => _handleGetContact(_currentUser!)),
        ListTile(
            title:
                gsignin.currentUser != null ? Text('SignOut') : Text('Signin'),
            onTap: () {
              if (gsignin.currentUser != null) {
                gsignin.googleLogout();
                Navigator.of(context).pushNamed('/');
              } else {
                gsignin.googleSignin();
                Navigator.of(context).pushNamed('/');
              }
            })
      ]);
    }));
  }
}
