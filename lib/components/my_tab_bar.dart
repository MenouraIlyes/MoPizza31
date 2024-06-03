import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: tabController,
        tabs: [
          // pizza tab
          Tab(
            icon: Icon(Icons.local_pizza),
          ),

          // pizza vip tab
          Tab(
            icon: Icon(Icons.local_pizza_rounded),
          ),

          // family tab
          Tab(
            icon: Icon(Icons.home),
          ),

          // drinks tab
          Tab(
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
