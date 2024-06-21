import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mopizza/models/cart_item.dart';

class FirestoreService {
  // get the collection of orders
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE: Add a new order
  Future<void> addOrder(List<CartItem> cartItems) async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('Error: No user is logged in');
      return;
    }

    List<Map<String, dynamic>> cartItemsMap =
        cartItems.map((item) => item.toMap()).toList();

    await _db.collection('orders').add({
      'order': cartItemsMap,
      'userId': user.uid, // Add user ID to the order
      'timestamp': Timestamp.now(),
    });
  }

  // READ: Get all orders from the database
  Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    QuerySnapshot snapshot =
        await _db.collection('orders').where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, 'data': doc.data()})
        .toList();
  }

  // UPDATE: Update an order with a doc id
  Future<void> updateOrder(String docId, List<CartItem> updatedCartItems) {
    List<Map<String, dynamic>> updatedCartItemsMap =
        updatedCartItems.map((item) => item.toMap()).toList();
    return orders.doc(docId).update({
      'order': updatedCartItemsMap,
      'timestamp': Timestamp.now(), // Update the timestamp if needed
    });
  }

  // DELETE: Delete an order from the database
  Future<void> deleteOrder(String docId) {
    return orders.doc(docId).delete();
  }
}
