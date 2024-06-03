import 'package:flutter/material.dart';
import 'package:mopizza/components/my_app_bar.dart';
import 'package:mopizza/components/my_current_location.dart';
import 'package:mopizza/components/my_description_box.dart';
import 'package:mopizza/components/my_drawer.dart';
import 'package:mopizza/components/my_tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MyAppBar(
            title: MyTabBar(tabController: _tabController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                // Current location
                const MyCurrentLocation(),

                // Description box
                const MyDescriptionBox(),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Pizza list
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const Text("First tab"),
            ),

            // Vip Pizza list
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const Text("Second tab"),
            ),

            // family list
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const Text("First tab"),
            ),

            // Drinks list
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const Text("Second tab"),
            ),
          ],
        ),
      ),
    );
  }
}
