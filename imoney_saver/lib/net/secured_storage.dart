import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GooleAuthSecureStorage {
  final storage = const FlutterSecureStorage();

  //Save Credentials
  Future saveCredentials(data) async {
    await storage.write(key: "accesstoken", value: data.accessToken);
    await storage.write(key: "name", value: data.name);
    await storage.write(key: "email", value: data.email);
    await storage.write(key: "photo", value: data.photo);
  }

  //Get Saved Credentials
  Future<Map<String, dynamic>?> getCredentials() async {
    var result = await storage.readAll();
    if (result.isEmpty) return null;
    return result;
  }

  //Clear Saved Credentials
  Future clear() {
    return storage.deleteAll();
  }
}
