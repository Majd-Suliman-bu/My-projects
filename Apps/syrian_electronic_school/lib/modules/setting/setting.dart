import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/DrawerV2.dart';
import '../../config/constant.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'welcome',
          style: TextStyle(color: white),
        ),
        backgroundColor: red,

      ),
      backgroundColor: white,

      drawer: MyDrawer(),
      body:

         const Center(child:Text("setting page"),)


    );
  }
}
