import 'package:flutter/material.dart';

class VideocallPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placeholder'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // Adjust the height as needed
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            ),
          ),
        ),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            // Add your navigation or functionality for entering the video call here
            print("Enter video call tapped");
          },
          child: Text(
            'Enter video call',
            style: TextStyle(
              color: Color.fromARGB(255, 106, 168, 219),
              fontSize: 20,
              decoration:
                  TextDecoration.underline, // This makes the text underlined
            ),
          ),
        ),
      ),
    );
  }
}
