import 'package:flutter/material.dart';
import 'package:imoney_saver/provider/googlesignin_provider.dart';
import 'package:provider/provider.dart';

class BackupSetting extends StatefulWidget {
  const BackupSetting({Key? key}) : super(key: key);
  @override
  BackupSettingState createState() => BackupSettingState();
}

class BackupSettingState extends State<BackupSetting> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<GoogleSignInProvider>(context).listGoogleDriveFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Backup Setting'), actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Consumer<GoogleSignInProvider>(
                builder: (context, googleProvider, child) {
                  return IconButton(
                      onPressed: () => googleProvider.listGoogleDriveFiles(),
                      //
                      icon: const Icon(Icons.replay_circle_filled_rounded,
                          size: 25));
                },
              )),
        ]),
        body: Column(
          children: [
            Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                margin: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 10, right: 10),
                child: Consumer<GoogleSignInProvider>(
                    builder: (context, googleProvider, child) {
                  return InkWell(
                      onTap: () {
                        googleProvider.uploadFileToGoogleDrive();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Google Drive File: ${googleProvider.filename}')
                              ])));
                })
                // ),
                ),
            Expanded(
                child: FutureBuilder(
                    future: Provider.of<GoogleSignInProvider>(context)
                        .listGoogleDriveFiles(),
                    builder: (context, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? const Center(
                            child: Text('no data found'),
                          )
                        : Consumer<GoogleSignInProvider>(
                            builder: (context, googleProvider, child) {
                            return ListView.builder(
                                itemCount:
                                    googleProvider.filelist?.files?.length,
                                itemBuilder: (context, i) {
                                  return BackupListCard(
                                    name: googleProvider
                                        .filelist?.files![i].name
                                        .toString(),
                                    id: googleProvider.filelist?.files![i].id
                                        .toString(),
                                  );
                                });
                          })))
          ],
        ));
  }
}

class BackupListCard extends StatefulWidget {
  final String? name;
  final String? id;

  const BackupListCard({this.name, this.id, Key? key}) : super(key: key);

  @override
  BackupListState createState() => BackupListState();
}

class BackupListState extends State<BackupListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
        margin: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
        child: Consumer<GoogleSignInProvider>(
            builder: (context, googleProvider, child) => InkWell(
                onTap: () {
                  googleProvider.downloadGoogleDriveFile(
                      widget.name.toString(), widget.id.toString());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.name.toString()),
                    Text(widget.id.toString())
                  ],
                ))));
  }
}
