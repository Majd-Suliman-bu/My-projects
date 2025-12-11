import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define a list of pages for easy iteration
    final List<Map<String, dynamic>> pages = [
      {'name': 'Splash', 'route': '/Splash'},
      {'name': 'TabView', 'route': '/TabView'},
      {'name': 'ChatBot', 'route': '/ChatBot'},
      {'name': 'Profile', 'route': '/Profile'},
      {'name': 'Doctors', 'route': '/Doctors'},
      {'name': 'DoctorProfile', 'route': '/DoctorProfile'},
      {'name': 'Reservations', 'route': '/Reservations'},
      {'name': 'MyTherapists', 'route': '/MyTherapists'},
      {'name': 'ChatPage', 'route': '/ChatPage'},
      {'name': 'VideoCallPage', 'route': '/VideoCallPage'},
      {'name': 'ChatPagem', 'route': '/ChatPagem'},
      {'name': 'Login', 'route': '/Login'},

      // Add more pages as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigator'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10, // Horizontal space between items
          mainAxisSpacing: 10, // Vertical space between items
        ),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // if (pages[index]['route'] == '/ChatPagem') {
              //   Get.to(() => BlocProvider(
              //         create: (context) => ChatBloc(
              //             chatRepositoryImp:
              //                 ChatRepositoryImp(chatDataSource: sl())),
              //         child: const ChatPagem(),
              //       ));
              // } else {
              Get.toNamed(pages[index]['route']);
              // }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  pages[index]['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
