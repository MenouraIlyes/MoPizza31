import 'package:flutter/material.dart';
import 'package:mopizza/components/my_drawer_tile.dart';
import 'package:mopizza/pages/cart_page.dart';
import 'package:mopizza/pages/settings_page.dart';
import 'package:mopizza/screens/orders_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          //app logo
          Padding(
            padding: const EdgeInsets.only(top: 100.0),

            // Logo
            child: Image.asset(
              'assets/logo.png',
              width: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Colors.grey[400],
            ),
          ),

          //home list tile
          MyDrawerTile(
            icon: Icons.home,
            text: "H O M E",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          //settings list tile
          MyDrawerTile(
            icon: Icons.settings,
            text: "S E T T I N G S",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ));
            },
          ),

          // cart orders
          MyDrawerTile(
            icon: Icons.shopping_cart_checkout,
            text: "O R D E R S",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersScreen(),
                  ));
            },
          ),

          const Spacer(),
          //Terms and conditions tile
          MyDrawerTile(
            icon: Icons.policy,
            text: "T E R M S / P O L I C Y ",
            onTap: () {},
          ),
          //logout list tile
          MyDrawerTile(
            icon: Icons.logout,
            text: "L O G O U T",
            onTap: () {},
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
