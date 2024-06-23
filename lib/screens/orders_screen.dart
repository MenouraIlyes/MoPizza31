import 'package:flutter/material.dart';
import 'package:mopizza/components/my_cart_tile.dart';
import 'package:mopizza/services/firestore.dart';
import 'package:mopizza/models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<OrderData> orders = [];
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('No user is logged in');
        setState(() {
          isLoading = false;
        });
        return;
      }

      String userId = user.uid;
      List<Map<String, dynamic>> ordersData =
          await _firestoreService.getOrders(userId);
      print('Fetched ordersData: $ordersData'); // Debug print

      List<OrderData> fetchedOrders = ordersData.map((orderData) {
        List<dynamic> cartItemsData = orderData['data']['order'] ?? [];
        List<CartItem> cartItems = cartItemsData
            .map((itemData) => CartItem.fromMap(itemData))
            .toList();
        return OrderData(docId: orderData['id'], cartItems: cartItems);
      }).toList();

      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });

      print('Fetched orders: $orders'); // Debug print
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteOrder(String docId, int index) async {
    if (docId.isEmpty) {
      print('Error: docId is empty');
      return;
    }
    await _firestoreService.deleteOrder(docId);
    setState(() {
      orders.removeAt(index);
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.expand_more),
                                    IconButton(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: const Text(
                                                'Are you sure you want to delete the order?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  deleteOrder(
                                                      order.docId, index);
                                                },
                                                child: const Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    )
                                  ],
                                ),
                                children: order.cartItems
                                    .map((cartItem) => MyCartTile(
                                          cartItem: cartItem,
                                          readOnly: true,
                                        ))
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

class OrderData {
  final String docId;
  final List<CartItem> cartItems;

  OrderData({required this.docId, required this.cartItems});
}
