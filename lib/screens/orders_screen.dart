import 'package:flutter/material.dart';
import 'package:mopizza/components/my_cart_tile.dart';
import 'package:mopizza/services/firestore.dart';
import 'package:mopizza/models/cart_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<List<CartItem>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    List<Map<String, dynamic>> ordersData = await _firestoreService.getOrders();
    List<List<CartItem>> fetchedOrders = ordersData.map((orderData) {
      List<dynamic> cartItemsData = orderData['order'];
      return cartItemsData
          .map((itemData) => CartItem.fromMap(itemData))
          .toList();
    }).toList();
    setState(() {
      orders = fetchedOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: orders.isEmpty
                  ? const Center(
                      child: Text(
                        "No orders found..",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return ExpansionTile(
                          title: Text('Order ${index + 1}'),
                          children: order
                              .map((cartItem) => MyCartTile(cartItem: cartItem))
                              .toList(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
