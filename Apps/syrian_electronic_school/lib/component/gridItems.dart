import 'package:flutter/material.dart';
import '../config/constant.dart';

class GridItem extends StatelessWidget {
  final String courseName;
  final String courseImage;
  final Function()? onTap;

  GridItem(
      {required this.courseName,
      required this.courseImage,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              offset: new Offset(0.0, 6.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.network(
              courseImage,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.25,
            ),
            SizedBox(height: 15.0),
            Text(
              courseName,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
