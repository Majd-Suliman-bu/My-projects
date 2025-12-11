import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/constant.dart';
import '../config/user_info.dart';
import '../../native_service/secure_storage.dart';
import 'redeemCodeDialog.dart';

class MyDrawer extends StatelessWidget {
  final Securestorage _storage = Securestorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Card(
            margin: EdgeInsets.all(15),
            elevation: 5,
            child: Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    UserInfo.user_name,
                    style: TextStyle(
                        color: textcolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(
                    UserInfo.user_email,
                    style: TextStyle(
                      color: textcolor,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Icon(Icons.account_circle_rounded, size: 35),
                  onTap: () {},
                )),
          ),
          Card(
            margin: EdgeInsets.all(15),
            elevation: 5,
            child: Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.home_filled,
                        color: silver,
                      ),
                      title: const Text(
                        'Subjects',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Get.offNamed("/Home");
                      },
                    ),
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.dashboard,
                        color: silver,
                      ),
                      title: const Text(
                        'Courses',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed("/Courses");
                      },
                    ),
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.shopping_cart_rounded,
                        color: silver,
                      ),
                      title: const Text(
                        'MySubscriptions',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed("/MySubscriptions");
                      },
                    ),
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.folder_copy,
                        color: silver,
                      ),
                      title: const Text(
                        'local files',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed("/LocalFiles");
                      },
                    ),
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.download_sharp,
                        color: silver,
                      ),
                      title: const Text(
                        'Downloads',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed("/Downloads");
                      },
                    ),
                  ],
                )),
          ),
          Card(
            margin: EdgeInsets.all(15),
            elevation: 5,
            child: Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.add,
                        color: silver,
                      ),
                      title: const Text(
                        'Redeem code',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              true, // Allow dismissing by tapping outside
                          builder: (BuildContext context) {
                            return RedeemCodeDialog();
                          },
                        );
                      },
                    ),
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.settings,
                        color: silver,
                      ),
                      title: const Text(
                        'Setting',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Get.offNamed("/Setting");
                      },
                    ),
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.info,
                        color: silver,
                      ),
                      title: const Text(
                        'About us',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed("/AboutUs");
                      },
                    ),
                  ],
                )),
          ),
          Card(
            margin: EdgeInsets.all(15),
            elevation: 5,
            child: Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      minLeadingWidth: 10,
                      leading: const Icon(
                        Icons.exit_to_app_outlined,
                        color: silver,
                      ),
                      title: const Text(
                        'LOG OUT',
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        _storage.delete("Access Token");
                        _storage.delete("Refresh Token");
                        _storage.delete("User name");
                        _storage.delete("intrest");
                        Get.offAllNamed("/Landing");
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
