import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TemporaryNavigator extends StatefulWidget {
  @override
  _TemporaryNavigatorState createState() => _TemporaryNavigatorState();
}

class _TemporaryNavigatorState extends State<TemporaryNavigator> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Check if the token is null
        String? token = await _storage.read(key: "accessToken");

        if (token == null) {
          print('token is null');
          // Navigate to the login screen if the token is null
          Get.offNamed('/Landing');
        } else {
          print('token is not null :$token');
          // Navigate to the TabView screen if the token is not null
          Get.offNamed('/TabView');
        }
      } catch (e) {
        print('Error reading token: $e');
        // Handle the error, possibly navigate to an error screen or login screen
        Get.offNamed('/Landing');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Optionally, return a loading indicator or a blank screen
      child: Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      ),
    );
  }
}
