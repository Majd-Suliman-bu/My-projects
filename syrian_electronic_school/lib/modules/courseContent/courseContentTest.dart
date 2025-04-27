import 'package:flutter/material.dart';

import '../../config/constant.dart';

class CourseContentTest extends StatefulWidget {
  @override
  State<CourseContentTest> createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContentTest>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this); // Adjust length according to the number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Content'),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Container(
              color: lighterRed,
              child: Stack(
                children: [
                  Positioned(
                    left: 16.0,
                    top: 16.0,
                    child: Placeholder(

                      fallbackWidth: 100,
                      fallbackHeight: 100,
                    ),
                  ),
                  const Positioned(
                    right: 16.0,
                    top: 16.0,
                    child: Text(
                      'Course Title',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildDraggableScrollableSheet(),
        ],
      ),
    );
  }
  DraggableScrollableSheet _buildDraggableScrollableSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 1,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            // border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Scrollbar(
            child: ListView.builder(
              controller: scrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        );
      },
    );
  }
}


