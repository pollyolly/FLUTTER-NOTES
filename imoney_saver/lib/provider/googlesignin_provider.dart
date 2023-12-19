import 'package:firebase_auth/firebase_auth.dart'; //AuthCredential
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:imoney_saver/net/secured_storage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:imoney_saver/net/notification_api.dart';
import 'package:path_provider/path_provider.dart'; //IOClient
//https://preneure.com/upload-files-in-google-drive-using-flutter/

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
    drive.DriveApi.driveReadonlyScope
  ],
);

class GoogleSignInProvider with ChangeNotifier {
  GooleAuthSecureStorage storeAuth = GooleAuthSecureStorage();
  GoogleSignInAccount? _currentUser;
  // GoogleSignInAccount? _user;
  GoogleSignIn? googleUser;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _filename = "No file added!";
  String? get filename => _filename;
  GoogleSignInAccount? get currentUser => _currentUser;
  drive.FileList? _list;
  drive.FileList? get filelist => _list;
  String appFolder = "1nESDN0z_en_3sW_XNCWXtfQmawULUtUt";
  GoogleSignInProvider() {
    initGoogle();

    // print('Google Signin Constructor called!');
  }

  Future<void> initGoogle() async {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        _currentUser = account;
        _afterGoogleLogin(account);
      } else {
        _currentUser = null;
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> googleSignin() async {
    try {
      await _googleSignIn.signIn();
      await initGoogle();
    } catch (error) {}
  }

  Future<void> googleLogout() async {
    await _googleSignIn.disconnect();
    await initGoogle();
    storeAuth.clear();
  }

  Future<void> uploadFileToGoogleDrive() async {
    var client = GoogleHttpClient(await _currentUser!.authHeaders);
    var drive2 = drive.DriveApi(client);
    drive.File fileToUpload = drive.File();
    FilePickerResult? fresult = await FilePicker.platform.pickFiles();
    PlatformFile? file;
    if (fresult != null) {
      file = fresult.files.first;
      fileToUpload.parents = [appFolder]; //imoney_saver_backup
      fileToUpload.name = file.name;
      File data = File(fresult.files.single.path!);
      var response = await drive2.files.create(fileToUpload,
          uploadMedia: drive.Media(data.openRead(), data.lengthSync()));

      // print(response);
      if (response.name != null) {
        _filename = response.name;
        await NotificationApi.showNotification(
            title: 'Google Drive Upload',
            body: 'Successfully uploaded the file ${response.name}',
            payload: 'test payload');
      }
    } else {
      await NotificationApi.showNotification(
          title: 'Google Drive Upload',
          body: 'Failed to upload the file ${file?.name}',
          payload: 'test payload');
    }
    await listGoogleDriveFiles();
  }
//For Testing Stream Upload //Working
  // Future<void> uploadFileToGoogleDrive() async {
  //   var client = GoogleHttpClient(await _currentUser!.authHeaders);
  //   var drive2 = drive.DriveApi(client);
  //   var fileToUpload = drive.File();
  //   fileToUpload.parents = [
  //     "1nESDN0z_en_3sW_XNCWXtfQmawULUtUt"
  //   ]; //imoney_saver_backup
  //   fileToUpload.name = "hello_world.txt";
  //   final Stream<List<int>> mediaStream =
  //       Future.value([104, 105]).asStream().asBroadcastStream();
  //   await drive2.files
  //       .create(fileToUpload, uploadMedia: drive.Media(mediaStream, 2));
  // }

  Future<void> listGoogleDriveFiles() async {
    var client = GoogleHttpClient(await _currentUser!.authHeaders);
    var drive2 = drive.DriveApi(client);
    drive2.files
        .list(spaces: 'drive', q: "'$appFolder' in parents")
        .then((value) {
      // ignore: unnecessary_null_comparison

      _list = value;

      // for (var i = 0; i < _list!.files!.length; i++) {
      //   print("Id: ${_list!.files![i].id} File Name:${_list!.files![i].name}");
      // }
    });
  }

  Future<void> downloadGoogleDriveFile(String fName, String gdID) async {
    var client = GoogleHttpClient(await _currentUser!.authHeaders);
    var drive2 = drive.DriveApi(client);
    // https://developers.google.com/drive/api/v3/reference/files/list?apix_params=%7B%22fields%22%3A%22files(parents)%22%7D
    drive.Media? file = await drive2.files.export(gdID, '*',
        $fields: '*', downloadOptions: drive.DownloadOptions.fullMedia);
    print(file?.stream);

    final directory = await getExternalStorageDirectory();
    print(directory?.path);
    final saveFile = File(
        '${directory?.path}/${DateTime.now().millisecondsSinceEpoch}$fName');
    List<int> dataStore = [];
    file?.stream.listen((data) {
      print("DataReceived: ${data.length}");
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () {
      print("Task Done");
      saveFile.writeAsBytes(dataStore);
      print("File saved at ${saveFile.path}");
    }, onError: (error) {
      print("Some Error");
    });
  }

  // List<Widget> generateFilesWidget() {
  //   List<Widget> listItem = List<Widget>();
  //   if (_list != null) {
  //     for (var i = 0; i < _list.files!.length; i++) {
  //       listItem.add(Row(
  //         children: <Widget>[
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.05,
  //             child: Text('${i + 1}'),
  //           ),
  //           Expanded(
  //             child: Text(_list.files[i].name),
  //           ),
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.3,
  //             child: FlatButton(
  //               child: Text(
  //                 'Download',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               color: Colors.indigo,
  //               onPressed: () {
  //                 _downloadGoogleDriveFile(
  //                     list.files[i].name, list.files[i].id);
  //               },
  //             ),
  //           ),
  //         ],
  //       ));
  //     }
  //   }
  //   return listItem;
  // }

  Future<void> _afterGoogleLogin(GoogleSignInAccount gSA) async {
    _currentUser = gSA;

    final GoogleSignInAuthentication? googleSignInAuth =
        await _currentUser?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuth?.idToken,
        accessToken: googleSignInAuth?.accessToken);
    FirebaseAuth auth = FirebaseAuth.instance;

    final Future<UserCredential> authResult =
        auth.signInWithCredential(credential);
    final Future<User?> user = authResult.then((value) => value.user);
    Future<bool?> isanonymous = user.then((value) => value?.isAnonymous);
    // ignore: unrelated_type_equality_checks
    assert(isanonymous == false);

    final User? curuser = auth.currentUser;
    var useruid = user.then((value) => value?.uid);

    // ignore: unrelated_type_equality_checks
    assert(useruid == curuser?.uid);

    //   await storeAuth.saveCredentials({
    //     'accessToken': googleSignInAuth?.accessToken,
    //     'name': _currentUser?.displayName,
    //     'email': _currentUser?.email,
    //     'photo': _currentUser?.photoUrl
    //   });
  }
}

class GoogleHttpClient extends IOClient {
  final Map<String, String> _headers;
  GoogleHttpClient(this._headers) : super();
  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));
  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url, headers: headers?..addAll(_headers));
}
