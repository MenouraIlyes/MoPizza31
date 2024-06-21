import 'package:flutter/material.dart';
import 'package:mopizza/components/my_drawer_tile.dart';
import 'package:mopizza/pages/cart_page.dart';
import 'package:mopizza/pages/settings_page.dart';
import 'package:mopizza/screens/auth_screen.dart';
import 'package:mopizza/screens/orders_screen.dart';
import 'package:mopizza/services/auth.dart';
import 'package:mopizza/services/firestore.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final AuthService _authService = AuthService();

  Future<bool> _confirmSignOut(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: const Text('Confirm Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    bool shouldSignOut = await _confirmSignOut(context);
    if (shouldSignOut) {
      await _authService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    }
  }

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
            onTap: () => _handleSignOut(context),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
